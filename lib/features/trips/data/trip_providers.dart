import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/entitlement/premium_gate.dart';
import 'package:tripmate/core/providers/core_providers.dart';
import 'package:tripmate/core/sync/sync_providers.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/trips/data/datasources/trip_dao.dart';
import 'package:tripmate/features/trips/data/datasources/trip_remote_data_source.dart';
import 'package:tripmate/features/trips/data/repositories/trip_repository_impl.dart';
import 'package:tripmate/features/trips/data/trip_sync_handler.dart';
import 'package:tripmate/features/trips/domain/entities/trip.dart';
import 'package:tripmate/features/trips/domain/repositories/trip_repository.dart';

part 'trip_providers.g.dart';

@Riverpod(keepAlive: true)
TripDao tripDao(Ref ref) => TripDao(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
TripRemoteDataSource tripRemoteDataSource(Ref ref) {
  return TripRemoteDataSource(ref.watch(supabaseClientProvider));
}

/// Sync handler for trips, registered with the engine via [syncHandlersProvider]
/// override in the composition root (Architecture §6).
@Riverpod(keepAlive: true)
TripSyncHandler tripSyncHandler(Ref ref) {
  return TripSyncHandler(
    dao: ref.watch(tripDaoProvider),
    remote: ref.watch(tripRemoteDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
TripRepository tripRepository(Ref ref) {
  final repository = TripRepositoryImpl(
    dao: ref.watch(tripDaoProvider),
    queueDao: ref.watch(syncQueueDaoProvider),
    remote: ref.watch(tripRemoteDataSourceProvider),
    syncEngine: ref.watch(syncEngineProvider),
    authRepository: ref.watch(authRepositoryProvider),
    logger: ref.watch(appLoggerProvider),
    // Premium bypasses the free-tier active-trip cap (PRD §12, Sprint 7).
    hasUnlimitedTrips: () => ref.read(premiumGateProvider),
  );
  ref.onDispose(repository.dispose);
  return repository;
}

/// Active trips stream for the Home screen (UI/UX §3.5).
@riverpod
Stream<List<Trip>> activeTrips(Ref ref) {
  return ref.watch(tripRepositoryProvider).watchActiveTrips();
}

/// Archived trips stream (UI/UX §3.17).
@riverpod
Stream<List<Trip>> archivedTrips(Ref ref) {
  return ref.watch(tripRepositoryProvider).watchArchivedTrips();
}

/// Single trip stream for the Dashboard (UI/UX §3.7).
@riverpod
Stream<Trip?> tripById(Ref ref, String tripId) {
  return ref.watch(tripRepositoryProvider).watchTrip(tripId);
}
