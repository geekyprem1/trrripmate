import 'dart:async';

import 'package:drift/drift.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/error/result.dart';
import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/core/sync/sync_engine.dart';
import 'package:tripmate/core/sync/sync_queue_dao.dart';
import 'package:tripmate/core/sync/sync_types.dart';
import 'package:tripmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:tripmate/features/expenses/data/datasources/expense_dao.dart';
import 'package:tripmate/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:tripmate/features/expenses/data/datasources/receipt_remote_data_source.dart';
import 'package:tripmate/features/expenses/data/expense_error_mapper.dart';
import 'package:tripmate/features/expenses/data/mappers/expense_mappers.dart';
import 'package:tripmate/features/expenses/domain/entities/expense.dart';
import 'package:tripmate/features/expenses/domain/repositories/expense_repository.dart';
import 'package:tripmate/features/expenses/domain/split_calculator.dart';
import 'package:tripmate/features/members/data/datasources/member_dao.dart';
import 'package:uuid/uuid.dart';

/// Offline-first [ExpenseRepository]: reads stream from Drift; writes commit to
/// Drift (expense + splits in one transaction) then enqueue and return
/// (CLAUDE.md §5/§14). Conflict resolution on ingest is LWW + protect-pending.
class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl({
    required ExpenseDao dao,
    required MemberDao memberDao,
    required SyncQueueDao queueDao,
    required ExpenseRemoteDataSource remote,
    required ReceiptRemoteDataSource receipts,
    required SyncEngine syncEngine,
    required AuthRepository authRepository,
    required AppLogger logger,
    Uuid uuid = const Uuid(),
    DateTime Function() clock = DateTime.now,
  })  : _dao = dao,
        _memberDao = memberDao,
        _queueDao = queueDao,
        _remote = remote,
        _receipts = receipts,
        _syncEngine = syncEngine,
        _auth = authRepository,
        _logger = logger,
        _uuid = uuid,
        _clock = clock;

  static const _tag = 'expenses';

  final ExpenseDao _dao;
  final MemberDao _memberDao;
  final SyncQueueDao _queueDao;
  final ExpenseRemoteDataSource _remote;
  final ReceiptRemoteDataSource _receipts;
  final SyncEngine _syncEngine;
  final AuthRepository _auth;
  final AppLogger _logger;
  final Uuid _uuid;
  final DateTime Function() _clock;

  final Map<String, StreamSubscription<void>> _subs = {};

  @override
  Stream<List<Expense>> watchExpenses(String tripId) {
    return _dao
        .watchExpenses(tripId)
        .map((rows) => rows.map((r) => r.toEntity(const [])).toList());
  }

  @override
  Stream<List<Expense>> watchPending(String tripId) {
    return _dao
        .watchPending(tripId)
        .map((rows) => rows.map((r) => r.toEntity(const [])).toList());
  }

  @override
  Stream<Expense?> watchExpense(String expenseId) {
    return _dao.watchExpense(expenseId).asyncMap((row) async {
      if (row == null) return null;
      final splits = await _dao.getSplits(expenseId);
      return row.toEntity(splits);
    });
  }

  @override
  Stream<int> watchApprovedSpentMinor(String tripId) {
    return _dao.watchApprovedSpentMinor(tripId);
  }

  @override
  Stream<List<Expense>> watchApprovedWithSplits(String tripId) {
    return _dao.watchApprovedExpenses(tripId).asyncMap((rows) async {
      final splits = await _dao.getApprovedSplitsForTrip(tripId);
      final byExpense = <String, List<ExpenseSplitRow>>{};
      for (final split in splits) {
        (byExpense[split.expenseId] ??= []).add(split);
      }
      return rows
          .map((r) => r.toEntity(byExpense[r.id] ?? const []))
          .toList();
    });
  }

  @override
  Future<Result<Expense>> createExpense({
    required String tripId,
    required String currency,
    required ExpenseDraft draft,
  }) async {
    final userId = _auth.currentUser?.id;
    if (userId == null) return _sessionExpired();

    final validation = _validate(draft);
    if (validation != null) return Result.failure(validation);

    final splits = SplitCalculator.equalSplit(
      amountMinor: draft.amountMinor,
      memberIds: draft.splitMemberIds,
      payerMemberId: draft.paidByMemberId,
    );

    // Approval rule (PRD REQ-EXP-01/04): owner-added expenses are approved
    // immediately; member-added expenses await owner approval.
    final myMember = await _memberDao.getMemberForUser(tripId, userId);
    final status = myMember?.role == 'owner' ? 'approved' : 'pending';

    final id = _uuid.v4();
    final now = _clock();
    final hasReceipt = draft.receiptLocalPath != null;
    final row = ExpenseRow(
      id: id,
      tripId: tripId,
      paidByMemberId: draft.paidByMemberId,
      amountMinor: draft.amountMinor,
      currency: currency,
      category: draft.category.name,
      description: draft.description,
      expenseDate: draft.date,
      status: status,
      splitType: 'equal',
      receiptLocalPath: draft.receiptLocalPath,
      receiptUploadStatus: hasReceipt ? 'pending' : null,
      createdBy: userId,
      createdAt: now,
      updatedAt: now,
      version: 1,
      syncStatus: 'pending',
    );
    final splitRows = _toSplitRows(id, splits);

    try {
      await _dao.upsertWithSplits(row, splitRows);
      await _enqueue(ExpenseSyncOp.create, id);
      if (hasReceipt) await _enqueue(ExpenseSyncOp.receipt, id);
      unawaited(_syncEngine.requestSync());
      return Result.success(row.toEntity(splitRows));
    } catch (error, stackTrace) {
      return _fail('createExpense', error, stackTrace);
    }
  }

  @override
  Future<Result<Expense>> updateExpense({
    required String expenseId,
    required ExpenseDraft draft,
  }) async {
    final existing = await _dao.getExpense(expenseId);
    if (existing == null) {
      return const Result.failure(
          Failure.unknown(message: 'Expense not found.'));
    }
    final validation = _validate(draft);
    if (validation != null) return Result.failure(validation);

    final splits = SplitCalculator.equalSplit(
      amountMinor: draft.amountMinor,
      memberIds: draft.splitMemberIds,
      payerMemberId: draft.paidByMemberId,
    );

    // Material change (amount/payer/splits) reverts an approved expense to
    // pending re-approval (PRD REQ-EXP-02).
    final oldSplitMembers =
        (await _dao.getSplits(expenseId)).map((s) => s.memberId).toSet();
    final isMaterial = existing.amountMinor != draft.amountMinor ||
        existing.paidByMemberId != draft.paidByMemberId ||
        !_sameMembers(oldSplitMembers, draft.splitMemberIds);
    final status = (existing.status == 'approved' && isMaterial)
        ? 'pending'
        : existing.status;

    final hasNewReceipt = draft.receiptLocalPath != null;
    final now = _clock();
    final row = existing.copyWith(
      paidByMemberId: draft.paidByMemberId,
      amountMinor: draft.amountMinor,
      category: draft.category.name,
      description: Value(draft.description),
      expenseDate: draft.date,
      status: status,
      receiptLocalPath: hasNewReceipt
          ? Value(draft.receiptLocalPath)
          : Value(existing.receiptLocalPath),
      receiptUploadStatus: hasNewReceipt
          ? const Value('pending')
          : Value(existing.receiptUploadStatus),
      updatedAt: now,
      version: existing.version + 1,
      syncStatus: 'pending',
    );
    final splitRows = _toSplitRows(expenseId, splits);

    try {
      await _dao.upsertWithSplits(row, splitRows);
      await _enqueue(ExpenseSyncOp.update, expenseId);
      if (hasNewReceipt) await _enqueue(ExpenseSyncOp.receipt, expenseId);
      unawaited(_syncEngine.requestSync());
      return Result.success(row.toEntity(splitRows));
    } catch (error, stackTrace) {
      return _fail('updateExpense', error, stackTrace);
    }
  }

  @override
  Future<Result<void>> deleteExpense(String expenseId) async {
    final existing = await _dao.getExpense(expenseId);
    if (existing == null) return const Result.success(null);
    final now = _clock();
    final row = existing.copyWith(
      deletedAt: Value(now),
      updatedAt: now,
      version: existing.version + 1,
      syncStatus: 'pending',
    );
    try {
      await _dao.upsertExpenseOnly(row);
      await _enqueue(ExpenseSyncOp.delete, expenseId);
      unawaited(_syncEngine.requestSync());
      return const Result.success(null);
    } catch (error, stackTrace) {
      return _fail('deleteExpense', error, stackTrace);
    }
  }

  @override
  Future<Result<Expense>> setStatus({
    required String expenseId,
    required ExpenseStatus status,
  }) async {
    final existing = await _dao.getExpense(expenseId);
    if (existing == null) {
      return const Result.failure(
          Failure.unknown(message: 'Expense not found.'));
    }
    final isApprove = status == ExpenseStatus.approved;
    final now = _clock();
    final row = existing.copyWith(
      status: expenseStatusToString(status),
      updatedAt: now,
      version: existing.version + 1,
      syncStatus: 'pending',
    );
    try {
      await _dao.upsertExpenseOnly(row);
      await _enqueue(
        isApprove ? ExpenseSyncOp.approve : ExpenseSyncOp.reject,
        expenseId,
      );
      unawaited(_syncEngine.requestSync());
      final splits = await _dao.getSplits(expenseId);
      return Result.success(row.toEntity(splits));
    } catch (error, stackTrace) {
      return _fail('setStatus', error, stackTrace);
    }
  }

  @override
  Future<Result<String>> receiptUrl(String expenseId) async {
    final existing = await _dao.getExpense(expenseId);
    if (existing == null) {
      return const Result.failure(Failure.storage(message: 'No receipt.'));
    }
    final storagePath = existing.receiptStoragePath;
    if (storagePath != null) {
      try {
        return Result.success(await _receipts.signedUrl(storagePath));
      } catch (error, stackTrace) {
        return _fail('receiptUrl', error, stackTrace);
      }
    }
    final localPath = existing.receiptLocalPath;
    if (localPath != null) return Result.success(localPath);
    return const Result.failure(Failure.storage(message: 'No receipt.'));
  }

  @override
  Future<void> refreshFromRemote(String tripId) async {
    await _pull(tripId);
    _subs[tripId] ??= _remote.watchExpenseChanges(tripId).listen(
          (_) => unawaited(_pull(tripId)),
          onError: (Object error, StackTrace _) =>
              _logger.warning(_tag, 'expense stream error: $error'),
        );
  }

  Future<void> _pull(String tripId) async {
    try {
      final dtos = await _remote.fetchExpenses(tripId);
      for (final dto in dtos) {
        final local = await _dao.getExpense(dto.id);
        final localIsNewerPending = local != null &&
            local.syncStatus != 'synced' &&
            !dto.updatedAt.isAfter(local.updatedAt);
        if (localIsNewerPending) continue;
        await _dao.upsertWithSplits(
          expenseDtoToRow(dto),
          splitDtosToRows(dto),
        );
      }
    } catch (error) {
      _logger.warning(_tag, 'refreshFromRemote unavailable: $error');
    }
  }

  Future<void> dispose() async {
    for (final sub in _subs.values) {
      await sub.cancel();
    }
    _subs.clear();
  }

  Failure? _validate(ExpenseDraft draft) {
    if (draft.amountMinor <= 0) {
      return const Failure.validation(
        message: 'Amount must be greater than zero.',
        field: 'amount',
      );
    }
    return null;
  }

  bool _sameMembers(Set<String> a, List<String> b) {
    return a.length == b.length && a.containsAll(b);
  }

  List<ExpenseSplitRow> _toSplitRows(
      String expenseId, List<ExpenseSplit> splits) {
    return [
      for (final s in splits)
        ExpenseSplitRow(
          id: '$expenseId:${s.memberId}',
          expenseId: expenseId,
          memberId: s.memberId,
          shareMinor: s.shareMinor,
        ),
    ];
  }

  Future<void> _enqueue(String operation, String entityId) {
    return _queueDao.enqueue(
      SyncQueueItemsCompanion.insert(
        id: _uuid.v4(),
        entityType: SyncEntityType.expense,
        entityId: entityId,
        operation: operation,
        payload: '{}',
        createdAt: _clock(),
      ),
    );
  }

  Result<T> _sessionExpired<T>() {
    return const Result.failure(
      Failure.auth(
        message: 'Your session has expired. Please sign in again.',
        code: 'AUTH_SESSION_EXPIRED',
      ),
    );
  }

  Result<T> _fail<T>(String action, Object error, StackTrace stackTrace) {
    final failure = mapExpenseError(error);
    _logger.error(_tag, '$action failed', error: error, stackTrace: stackTrace);
    return Result.failure(failure);
  }
}
