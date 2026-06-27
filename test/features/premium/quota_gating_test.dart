import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/logging/app_logger.dart';
import 'package:tripmate/core/sync/sync_engine.dart';
import 'package:tripmate/core/sync/sync_queue_dao.dart';
import 'package:tripmate/features/auth/domain/entities/auth_user.dart';
import 'package:tripmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:tripmate/features/trips/data/datasources/trip_dao.dart';
import 'package:tripmate/features/trips/data/datasources/trip_remote_data_source.dart';
import 'package:tripmate/features/trips/data/repositories/trip_repository_impl.dart';
import 'package:tripmate/features/trips/domain/repositories/trip_repository.dart';

class _MockTripDao extends Mock implements TripDao {}

class _MockSyncQueueDao extends Mock implements SyncQueueDao {}

class _MockTripRemoteDataSource extends Mock implements TripRemoteDataSource {}

class _MockSyncEngine extends Mock implements SyncEngine {}

class _MockAuthRepository extends Mock implements AuthRepository {}

TripRow _row(String id) => TripRow(
      id: id,
      ownerId: 'u1',
      name: 'Trip $id',
      currency: 'INR',
      status: 'active',
      createdAt: DateTime(2026, 7),
      updatedAt: DateTime(2026, 7),
      version: 1,
      syncStatus: 'synced',
    );

/// Builds a [TripRepositoryImpl] with the given [isPremium] gate.
TripRepositoryImpl _makeRepo({
  required _MockTripDao dao,
  required _MockSyncQueueDao queueDao,
  required _MockAuthRepository auth,
  required _MockSyncEngine engine,
  bool isPremium = false,
}) {
  return TripRepositoryImpl(
    dao: dao,
    queueDao: queueDao,
    remote: _MockTripRemoteDataSource(),
    syncEngine: engine,
    authRepository: auth,
    logger: AppLogger('off'),
    clock: () => DateTime(2026, 7),
    hasUnlimitedTrips: () => isPremium,
  );
}

void main() {
  late _MockTripDao dao;
  late _MockSyncQueueDao queueDao;
  late _MockAuthRepository auth;
  late _MockSyncEngine engine;

  setUpAll(() {
    registerFallbackValue(_row('fallback'));
    registerFallbackValue(const SyncQueueItemsCompanion());
  });

  setUp(() {
    dao = _MockTripDao();
    queueDao = _MockSyncQueueDao();
    auth = _MockAuthRepository();
    engine = _MockSyncEngine();

    when(() => auth.currentUser).thenReturn(const AuthUser(id: 'u1'));
    when(() => dao.upsertTrip(any())).thenAnswer((_) async {});
    when(() => queueDao.enqueue(any())).thenAnswer((_) async {});
    when(() => engine.requestSync()).thenAnswer((_) async {});
  });

  group('free-tier quota gating', () {
    test('blocks the 4th active trip for a free user', () async {
      when(() => dao.countActiveTrips()).thenAnswer((_) async => 3);
      final repo =
          _makeRepo(dao: dao, queueDao: queueDao, auth: auth, engine: engine);

      final result = await repo.createTrip(
          const TripDraft(name: 'Overflow trip', currency: 'INR'));

      expect(result.isSuccess, isFalse);
      expect(result.failureOrNull, isA<QuotaFailure>());
      verifyNever(() => dao.upsertTrip(any()));
    });

    test('allows the 3rd active trip for a free user (boundary)', () async {
      when(() => dao.countActiveTrips()).thenAnswer((_) async => 2);
      final repo =
          _makeRepo(dao: dao, queueDao: queueDao, auth: auth, engine: engine);

      final result =
          await repo.createTrip(const TripDraft(name: 'Third', currency: 'INR'));

      expect(result.isSuccess, isTrue);
    });

    test('allows unlimited trips for a Premium user', () async {
      when(() => dao.countActiveTrips()).thenAnswer((_) async => 10);
      final repo = _makeRepo(
        dao: dao,
        queueDao: queueDao,
        auth: auth,
        engine: engine,
        isPremium: true,
      );

      final result = await repo.createTrip(
          const TripDraft(name: 'Premium overflow', currency: 'INR'));

      expect(result.isSuccess, isTrue);
      // countActiveTrips must NOT be called when isPremium bypasses the check.
      verifyNever(() => dao.countActiveTrips());
    });

    test('allows 0 active trips for a free user (empty state)', () async {
      when(() => dao.countActiveTrips()).thenAnswer((_) async => 0);
      final repo =
          _makeRepo(dao: dao, queueDao: queueDao, auth: auth, engine: engine);

      final result =
          await repo.createTrip(const TripDraft(name: 'First', currency: 'INR'));

      expect(result.isSuccess, isTrue);
    });
  });
}
