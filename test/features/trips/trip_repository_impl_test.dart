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

TripRow _row(String id, String name, {String status = 'active'}) {
  return TripRow(
    id: id,
    ownerId: 'u1',
    name: name,
    currency: 'INR',
    status: status,
    createdAt: DateTime(2026, 7),
    updatedAt: DateTime(2026, 7),
    version: 1,
    syncStatus: 'synced',
  );
}

void main() {
  late _MockTripDao dao;
  late _MockSyncQueueDao queueDao;
  late _MockTripRemoteDataSource remote;
  late _MockSyncEngine engine;
  late _MockAuthRepository auth;
  late TripRepositoryImpl repo;

  setUpAll(() {
    registerFallbackValue(_row('f', 'fallback'));
    registerFallbackValue(const SyncQueueItemsCompanion());
  });

  setUp(() {
    dao = _MockTripDao();
    queueDao = _MockSyncQueueDao();
    remote = _MockTripRemoteDataSource();
    engine = _MockSyncEngine();
    auth = _MockAuthRepository();

    when(() => auth.currentUser).thenReturn(const AuthUser(id: 'u1'));
    when(() => dao.countActiveTrips()).thenAnswer((_) async => 0);
    when(() => dao.upsertTrip(any())).thenAnswer((_) async {});
    when(() => queueDao.enqueue(any())).thenAnswer((_) async {});
    when(() => engine.requestSync()).thenAnswer((_) async {});

    repo = TripRepositoryImpl(
      dao: dao,
      queueDao: queueDao,
      remote: remote,
      syncEngine: engine,
      authRepository: auth,
      logger: AppLogger('off'),
      clock: () => DateTime(2026, 7),
    );
  });

  group('createTrip', () {
    test('writes locally, enqueues sync, and triggers a drain', () async {
      final result = await repo.createTrip(
        const TripDraft(name: 'Goa', currency: 'INR'),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.name, 'Goa');

      final captured =
          verify(() => dao.upsertTrip(captureAny())).captured.single as TripRow;
      expect(captured.name, 'Goa');
      expect(captured.syncStatus, 'pending');

      verify(() => queueDao.enqueue(any())).called(1);
      verify(() => engine.requestSync()).called(1);
    });

    test('enforces the free-tier limit of 3 active trips', () async {
      when(() => dao.countActiveTrips()).thenAnswer((_) async => 3);

      final result = await repo.createTrip(
        const TripDraft(name: 'Fourth', currency: 'INR'),
      );

      expect(result.failureOrNull, isA<QuotaFailure>());
      verifyNever(() => dao.upsertTrip(any()));
    });

    test('fails when there is no session', () async {
      when(() => auth.currentUser).thenReturn(null);

      final result = await repo.createTrip(
        const TripDraft(name: 'Goa', currency: 'INR'),
      );

      expect(result.failureOrNull, isA<AuthFailure>());
    });
  });

  group('setArchived', () {
    test('archives an existing trip', () async {
      when(() => dao.getTrip('t1')).thenAnswer((_) async => _row('t1', 'Goa'));

      final result = await repo.setArchived(id: 't1', archived: true);

      expect(result.isSuccess, isTrue);
      final captured =
          verify(() => dao.upsertTrip(captureAny())).captured.single as TripRow;
      expect(captured.status, 'archived');
      expect(captured.syncStatus, 'pending');
    });
  });

  group('deleteTrip', () {
    test('soft-deletes an existing trip', () async {
      when(() => dao.getTrip('t1')).thenAnswer((_) async => _row('t1', 'Goa'));

      final result = await repo.deleteTrip('t1');

      expect(result.isSuccess, isTrue);
      final captured =
          verify(() => dao.upsertTrip(captureAny())).captured.single as TripRow;
      expect(captured.status, 'deleted');
      expect(captured.deletedAt, isNotNull);
    });

    test('is idempotent when the trip is already gone', () async {
      when(() => dao.getTrip('missing')).thenAnswer((_) async => null);

      final result = await repo.deleteTrip('missing');

      expect(result.isSuccess, isTrue);
      verifyNever(() => dao.upsertTrip(any()));
    });
  });
}
