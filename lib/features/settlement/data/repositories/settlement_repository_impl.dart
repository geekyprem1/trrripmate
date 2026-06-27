import 'dart:async';

import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/error/result.dart';
import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/core/sync/sync_engine.dart';
import 'package:tripmate/core/sync/sync_queue_dao.dart';
import 'package:tripmate/core/sync/sync_types.dart';
import 'package:tripmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:tripmate/features/members/data/datasources/member_dao.dart';
import 'package:tripmate/features/settlement/data/datasources/settlement_dao.dart';
import 'package:tripmate/features/settlement/data/datasources/settlement_remote_data_source.dart';
import 'package:tripmate/features/settlement/data/mappers/settlement_mappers.dart';
import 'package:tripmate/features/settlement/data/settlement_error_mapper.dart';
import 'package:tripmate/features/settlement/domain/entities/settlement.dart';
import 'package:tripmate/features/settlement/domain/repositories/settlement_repository.dart';
import 'package:uuid/uuid.dart';

/// Offline-first [SettlementRepository]: completed payments stream from Drift;
/// marking paid commits a completed ledger entry locally then enqueues and
/// returns (CLAUDE.md §5/§14). The outstanding graph is computed elsewhere.
class SettlementRepositoryImpl implements SettlementRepository {
  SettlementRepositoryImpl({
    required SettlementDao dao,
    required MemberDao memberDao,
    required SyncQueueDao queueDao,
    required SettlementRemoteDataSource remote,
    required SyncEngine syncEngine,
    required AuthRepository authRepository,
    required AppLogger logger,
    Uuid uuid = const Uuid(),
    DateTime Function() clock = DateTime.now,
  })  : _dao = dao,
        _memberDao = memberDao,
        _queueDao = queueDao,
        _remote = remote,
        _syncEngine = syncEngine,
        _auth = authRepository,
        _logger = logger,
        _uuid = uuid,
        _clock = clock;

  static const _tag = 'settlement';

  final SettlementDao _dao;
  final MemberDao _memberDao;
  final SyncQueueDao _queueDao;
  final SettlementRemoteDataSource _remote;
  final SyncEngine _syncEngine;
  final AuthRepository _auth;
  final AppLogger _logger;
  final Uuid _uuid;
  final DateTime Function() _clock;

  final Map<String, StreamSubscription<void>> _subs = {};

  @override
  Stream<List<Settlement>> watchCompleted(String tripId) {
    return _dao
        .watchCompleted(tripId)
        .map((rows) => rows.map((r) => r.toEntity()).toList());
  }

  @override
  Future<Result<void>> markPaid(Settlement transaction) async {
    final userId = _auth.currentUser?.id;
    if (userId == null) return _sessionExpired();

    if (transaction.amountMinor <= 0 ||
        transaction.fromMemberId == transaction.toMemberId) {
      return const Result.failure(
        Failure.validation(message: 'Invalid settlement.'),
      );
    }

    // Permission is enforced server-side (RLS/RPC); this is a UX guard only:
    // the debtor (payer) or the trip owner may mark a settlement paid.
    final myMember =
        await _memberDao.getMemberForUser(transaction.tripId, userId);
    if (myMember == null) return _sessionExpired();
    final canMark =
        myMember.role == 'owner' || myMember.id == transaction.fromMemberId;
    if (!canMark) {
      return const Result.failure(
        Failure.permission(
          message: 'Only the payer or trip owner can mark this paid.',
        ),
      );
    }

    final now = _clock();
    final row = SettlementRow(
      id: transaction.id ?? _uuid.v4(),
      tripId: transaction.tripId,
      fromMemberId: transaction.fromMemberId,
      toMemberId: transaction.toMemberId,
      amountMinor: transaction.amountMinor,
      status: 'completed',
      markedByMemberId: myMember.id,
      completedAt: now,
      createdAt: now,
      updatedAt: now,
      version: 1,
      syncStatus: 'pending',
    );

    try {
      await _dao.upsert(row);
      await _enqueue(SettlementSyncOp.markPaid, row.id);
      unawaited(_syncEngine.requestSync());
      return const Result.success(null);
    } catch (error, stackTrace) {
      final failure = mapSettlementError(error);
      _logger.error(_tag, 'markPaid failed',
          error: error, stackTrace: stackTrace);
      return Result.failure(failure);
    }
  }

  @override
  Future<void> refreshFromRemote(String tripId) async {
    await _pull(tripId);
    _subs[tripId] ??= _remote.watchSettlementChanges(tripId).listen(
          (_) => unawaited(_pull(tripId)),
          onError: (Object error, StackTrace _) =>
              _logger.warning(_tag, 'settlement stream error: $error'),
        );
  }

  Future<void> _pull(String tripId) async {
    try {
      final dtos = await _remote.fetchCompleted(tripId);
      for (final dto in dtos) {
        final local = await _dao.getSettlement(dto.id);
        final localIsNewerPending = local != null &&
            local.syncStatus != 'synced' &&
            !dto.updatedAt.isAfter(local.updatedAt);
        if (localIsNewerPending) continue;
        await _dao.upsert(settlementDtoToRow(dto));
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

  Future<void> _enqueue(String operation, String entityId) {
    return _queueDao.enqueue(
      SyncQueueItemsCompanion.insert(
        id: _uuid.v4(),
        entityType: SyncEntityType.settlement,
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
}
