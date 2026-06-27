import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/core/sync/sync_engine.dart';
import 'package:tripmate/core/sync/sync_queue_dao.dart';
import 'package:tripmate/features/auth/domain/entities/auth_user.dart';
import 'package:tripmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:tripmate/features/members/data/datasources/member_dao.dart';
import 'package:tripmate/features/settlement/data/datasources/settlement_dao.dart';
import 'package:tripmate/features/settlement/data/datasources/settlement_remote_data_source.dart';
import 'package:tripmate/features/settlement/data/repositories/settlement_repository_impl.dart';
import 'package:tripmate/features/settlement/domain/entities/settlement.dart';

class _MockSettlementDao extends Mock implements SettlementDao {}

class _MockMemberDao extends Mock implements MemberDao {}

class _MockSyncQueueDao extends Mock implements SyncQueueDao {}

class _MockSettlementRemote extends Mock implements SettlementRemoteDataSource {}

class _MockSyncEngine extends Mock implements SyncEngine {}

class _MockAuthRepository extends Mock implements AuthRepository {}

MemberRow _memberRow({
  required String id,
  required String userId,
  required String role,
}) {
  final now = DateTime(2026, 7);
  return MemberRow(
    id: id,
    tripId: 't1',
    userId: userId,
    role: role,
    status: 'active',
    joinedAt: now,
    updatedAt: now,
    syncStatus: 'synced',
  );
}

SettlementRow _settlementRow() {
  final now = DateTime(2026, 7);
  return SettlementRow(
    id: 's1',
    tripId: 't1',
    fromMemberId: 'm2',
    toMemberId: 'm1',
    amountMinor: 50000,
    status: 'completed',
    createdAt: now,
    updatedAt: now,
    version: 1,
    syncStatus: 'pending',
  );
}

Settlement _outstanding({String from = 'm2', String to = 'm1'}) {
  return Settlement(
    tripId: 't1',
    fromMemberId: from,
    toMemberId: to,
    amountMinor: 50000,
    status: SettlementStatus.pending,
  );
}

void main() {
  late _MockSettlementDao dao;
  late _MockMemberDao memberDao;
  late _MockSyncQueueDao queueDao;
  late _MockSettlementRemote remote;
  late _MockSyncEngine engine;
  late _MockAuthRepository auth;
  late SettlementRepositoryImpl repo;

  setUpAll(() {
    registerFallbackValue(_settlementRow());
    registerFallbackValue(const SyncQueueItemsCompanion());
  });

  setUp(() {
    dao = _MockSettlementDao();
    memberDao = _MockMemberDao();
    queueDao = _MockSyncQueueDao();
    remote = _MockSettlementRemote();
    engine = _MockSyncEngine();
    auth = _MockAuthRepository();

    when(() => auth.currentUser).thenReturn(const AuthUser(id: 'u2'));
    when(() => dao.upsert(any())).thenAnswer((_) async {});
    when(() => queueDao.enqueue(any())).thenAnswer((_) async {});
    when(() => engine.requestSync()).thenAnswer((_) async {});

    repo = SettlementRepositoryImpl(
      dao: dao,
      memberDao: memberDao,
      queueDao: queueDao,
      remote: remote,
      syncEngine: engine,
      authRepository: auth,
      logger: AppLogger('off'),
      clock: () => DateTime(2026, 7),
    );
  });

  group('markPaid permissions', () {
    test('debtor (the from_member) may mark their own payment paid', () async {
      when(() => memberDao.getMemberForUser('t1', 'u2')).thenAnswer(
        (_) async => _memberRow(id: 'm2', userId: 'u2', role: 'member'),
      );

      final result = await repo.markPaid(_outstanding());

      expect(result.isSuccess, isTrue);
      final row = verify(() => dao.upsert(captureAny())).captured.single
          as SettlementRow;
      expect(row.status, 'completed');
      expect(row.markedByMemberId, 'm2');
      verify(() => engine.requestSync()).called(1);
    });

    test('owner may mark any settlement paid', () async {
      when(() => memberDao.getMemberForUser('t1', 'u2')).thenAnswer(
        (_) async => _memberRow(id: 'm9', userId: 'u2', role: 'owner'),
      );

      final result = await repo.markPaid(_outstanding(from: 'm3'));

      expect(result.isSuccess, isTrue);
    });

    test('a non-owner, non-debtor is denied', () async {
      // u2 is member m5 — neither the owner nor the debtor (m2).
      when(() => memberDao.getMemberForUser('t1', 'u2')).thenAnswer(
        (_) async => _memberRow(id: 'm5', userId: 'u2', role: 'member'),
      );

      final result = await repo.markPaid(_outstanding());

      expect(result.failureOrNull, isA<PermissionFailure>());
      verifyNever(() => dao.upsert(any()));
    });
  });

  group('markPaid validation', () {
    test('rejects when there is no session', () async {
      when(() => auth.currentUser).thenReturn(null);

      final result = await repo.markPaid(_outstanding());

      expect(result.failureOrNull, isA<AuthFailure>());
      verifyNever(() => dao.upsert(any()));
    });

    test('rejects a self-transfer', () async {
      when(() => memberDao.getMemberForUser('t1', 'u2')).thenAnswer(
        (_) async => _memberRow(id: 'm2', userId: 'u2', role: 'owner'),
      );

      final result = await repo.markPaid(_outstanding(to: 'm2'));

      expect(result.failureOrNull, isA<ValidationFailure>());
    });
  });

  group('markPaid idempotency', () {
    test('reuses the transaction id as the ledger entry id', () async {
      when(() => memberDao.getMemberForUser('t1', 'u2')).thenAnswer(
        (_) async => _memberRow(id: 'm2', userId: 'u2', role: 'member'),
      );

      await repo.markPaid(
        _outstanding().copyWith(id: 'fixed-id'),
      );

      final row = verify(() => dao.upsert(captureAny())).captured.single
          as SettlementRow;
      expect(row.id, 'fixed-id');
    });
  });
}
