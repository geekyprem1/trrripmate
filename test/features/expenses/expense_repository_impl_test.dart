import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/core/sync/sync_engine.dart';
import 'package:tripmate/core/sync/sync_queue_dao.dart';
import 'package:tripmate/features/auth/domain/entities/auth_user.dart';
import 'package:tripmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:tripmate/features/expenses/data/datasources/expense_dao.dart';
import 'package:tripmate/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:tripmate/features/expenses/data/datasources/receipt_remote_data_source.dart';
import 'package:tripmate/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:tripmate/features/expenses/domain/entities/expense.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';
import 'package:tripmate/features/expenses/domain/repositories/expense_repository.dart';
import 'package:tripmate/features/members/data/datasources/member_dao.dart';

class _MockExpenseDao extends Mock implements ExpenseDao {}

class _MockMemberDao extends Mock implements MemberDao {}

class _MockSyncQueueDao extends Mock implements SyncQueueDao {}

class _MockExpenseRemote extends Mock implements ExpenseRemoteDataSource {}

class _MockReceiptRemote extends Mock implements ReceiptRemoteDataSource {}

class _MockSyncEngine extends Mock implements SyncEngine {}

class _MockAuthRepository extends Mock implements AuthRepository {}

ExpenseRow _expenseRow({
  String status = 'approved',
  int amountMinor = 90000,
  String paidBy = 'm1',
}) {
  final now = DateTime(2026, 7);
  return ExpenseRow(
    id: 'e1',
    tripId: 't1',
    paidByMemberId: paidBy,
    amountMinor: amountMinor,
    currency: 'INR',
    category: 'food',
    expenseDate: now,
    status: status,
    splitType: 'equal',
    createdBy: 'u1',
    createdAt: now,
    updatedAt: now,
    version: 1,
    syncStatus: 'synced',
  );
}

MemberRow _memberRow(String role) {
  final now = DateTime(2026, 7);
  return MemberRow(
    id: 'm1',
    tripId: 't1',
    userId: 'u1',
    role: role,
    status: 'active',
    joinedAt: now,
    updatedAt: now,
    syncStatus: 'synced',
  );
}

ExpenseSplitRow _splitRow(String memberId) {
  return ExpenseSplitRow(
    id: 'e1:$memberId',
    expenseId: 'e1',
    memberId: memberId,
    shareMinor: 45000,
  );
}

void main() {
  late _MockExpenseDao dao;
  late _MockMemberDao memberDao;
  late _MockSyncQueueDao queueDao;
  late _MockExpenseRemote remote;
  late _MockReceiptRemote receipts;
  late _MockSyncEngine engine;
  late _MockAuthRepository auth;
  late ExpenseRepositoryImpl repo;

  setUpAll(() {
    registerFallbackValue(_expenseRow());
    registerFallbackValue(const SyncQueueItemsCompanion());
  });

  setUp(() {
    dao = _MockExpenseDao();
    memberDao = _MockMemberDao();
    queueDao = _MockSyncQueueDao();
    remote = _MockExpenseRemote();
    receipts = _MockReceiptRemote();
    engine = _MockSyncEngine();
    auth = _MockAuthRepository();

    when(() => auth.currentUser).thenReturn(const AuthUser(id: 'u1'));
    when(() => dao.upsertWithSplits(any(), any())).thenAnswer((_) async {});
    when(() => dao.upsertExpenseOnly(any())).thenAnswer((_) async {});
    when(() => dao.getSplits(any())).thenAnswer((_) async => []);
    when(() => queueDao.enqueue(any())).thenAnswer((_) async {});
    when(() => engine.requestSync()).thenAnswer((_) async {});

    repo = ExpenseRepositoryImpl(
      dao: dao,
      memberDao: memberDao,
      queueDao: queueDao,
      remote: remote,
      receipts: receipts,
      syncEngine: engine,
      authRepository: auth,
      logger: AppLogger('off'),
      clock: () => DateTime(2026, 7),
    );
  });

  ExpenseDraft draft({int amountMinor = 90000, List<String>? members}) {
    return ExpenseDraft(
      amountMinor: amountMinor,
      category: ExpenseCategory.food,
      paidByMemberId: 'm1',
      splitMemberIds: members ?? const ['m1', 'm2'],
      date: DateTime(2026, 7),
    );
  }

  group('createExpense approval rule', () {
    test('owner-added expense is approved immediately', () async {
      when(() => memberDao.getMemberForUser('t1', 'u1'))
          .thenAnswer((_) async => _memberRow('owner'));

      final result = await repo.createExpense(
        tripId: 't1',
        currency: 'INR',
        draft: draft(),
      );

      expect(result.isSuccess, isTrue);
      final row = verify(() => dao.upsertWithSplits(captureAny(), any()))
          .captured
          .single as ExpenseRow;
      expect(row.status, 'approved');
      verify(() => engine.requestSync()).called(1);
    });

    test('member-added expense awaits approval (pending)', () async {
      when(() => memberDao.getMemberForUser('t1', 'u1'))
          .thenAnswer((_) async => _memberRow('member'));

      await repo.createExpense(
        tripId: 't1',
        currency: 'INR',
        draft: draft(),
      );

      final row = verify(() => dao.upsertWithSplits(captureAny(), any()))
          .captured
          .single as ExpenseRow;
      expect(row.status, 'pending');
    });
  });

  group('createExpense validation', () {
    test('rejects a non-positive amount', () async {
      final result = await repo.createExpense(
        tripId: 't1',
        currency: 'INR',
        draft: draft(amountMinor: 0),
      );
      expect(result.failureOrNull, isA<ValidationFailure>());
      verifyNever(() => dao.upsertWithSplits(any(), any()));
    });

    test('rejects when there is no session', () async {
      when(() => auth.currentUser).thenReturn(null);
      final result = await repo.createExpense(
        tripId: 't1',
        currency: 'INR',
        draft: draft(),
      );
      expect(result.failureOrNull, isA<AuthFailure>());
    });
  });

  group('updateExpense', () {
    test('reverts an approved expense to pending on amount change', () async {
      when(() => dao.getExpense('e1'))
          .thenAnswer((_) async => _expenseRow());
      when(() => dao.getSplits('e1'))
          .thenAnswer((_) async => [_splitRow('m1'), _splitRow('m2')]);

      await repo.updateExpense(
        expenseId: 'e1',
        draft: draft(amountMinor: 120000),
      );

      final row = verify(() => dao.upsertWithSplits(captureAny(), any()))
          .captured
          .single as ExpenseRow;
      expect(row.status, 'pending');
    });

    test('keeps approved status when nothing material changed', () async {
      when(() => dao.getExpense('e1'))
          .thenAnswer((_) async => _expenseRow());
      when(() => dao.getSplits('e1'))
          .thenAnswer((_) async => [_splitRow('m1'), _splitRow('m2')]);

      await repo.updateExpense(expenseId: 'e1', draft: draft());

      final row = verify(() => dao.upsertWithSplits(captureAny(), any()))
          .captured
          .single as ExpenseRow;
      expect(row.status, 'approved');
    });
  });

  group('deleteExpense', () {
    test('soft-deletes by setting deletedAt', () async {
      when(() => dao.getExpense('e1')).thenAnswer((_) async => _expenseRow());

      final result = await repo.deleteExpense('e1');

      expect(result.isSuccess, isTrue);
      final row = verify(() => dao.upsertExpenseOnly(captureAny()))
          .captured
          .single as ExpenseRow;
      expect(row.deletedAt, isNotNull);
    });
  });

  group('setStatus', () {
    test('approves a pending expense', () async {
      when(() => dao.getExpense('e1'))
          .thenAnswer((_) async => _expenseRow(status: 'pending'));

      final result = await repo.setStatus(
        expenseId: 'e1',
        status: ExpenseStatus.approved,
      );

      expect(result.isSuccess, isTrue);
      final row = verify(() => dao.upsertExpenseOnly(captureAny()))
          .captured
          .single as ExpenseRow;
      expect(row.status, 'approved');
    });
  });
}
