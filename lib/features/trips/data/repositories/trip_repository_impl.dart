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
import 'package:tripmate/features/trips/data/datasources/trip_dao.dart';
import 'package:tripmate/features/trips/data/datasources/trip_remote_data_source.dart';
import 'package:tripmate/features/trips/data/mappers/trip_mappers.dart';
import 'package:tripmate/features/trips/domain/entities/trip.dart';
import 'package:tripmate/features/trips/domain/repositories/trip_repository.dart';
import 'package:uuid/uuid.dart';

/// Offline-first [TripRepository]: reads stream from Drift; writes commit to
/// Drift then enqueue for sync and return immediately (CLAUDE.md §5/§14).
class TripRepositoryImpl implements TripRepository {
  TripRepositoryImpl({
    required TripDao dao,
    required SyncQueueDao queueDao,
    required TripRemoteDataSource remote,
    required SyncEngine syncEngine,
    required AuthRepository authRepository,
    required AppLogger logger,
    Uuid uuid = const Uuid(),
    DateTime Function() clock = DateTime.now,
    bool Function() hasUnlimitedTrips = _alwaysFalse,
  })  : _dao = dao,
        _queueDao = queueDao,
        _remote = remote,
        _syncEngine = syncEngine,
        _auth = authRepository,
        _logger = logger,
        _uuid = uuid,
        _clock = clock,
        _hasUnlimitedTrips = hasUnlimitedTrips;

  static bool _alwaysFalse() => false;

  static const _tag = 'trips';
  static const _freeTierTripLimit = 3;

  final TripDao _dao;
  final SyncQueueDao _queueDao;
  final TripRemoteDataSource _remote;
  final SyncEngine _syncEngine;
  final AuthRepository _auth;
  final AppLogger _logger;
  final Uuid _uuid;
  final DateTime Function() _clock;

  /// Premium bypasses the free-tier active-trip cap (PRD §12). Injected so the
  /// repo stays decoupled from the premium feature.
  final bool Function() _hasUnlimitedTrips;

  StreamSubscription<void>? _remoteSub;

  @override
  Stream<List<Trip>> watchActiveTrips() {
    return _dao.watchActiveTrips().map(_toEntities);
  }

  @override
  Stream<List<Trip>> watchArchivedTrips() {
    return _dao.watchArchivedTrips().map(_toEntities);
  }

  @override
  Stream<Trip?> watchTrip(String id) {
    return _dao.watchTrip(id).map((row) => row?.toEntity());
  }

  @override
  Future<Result<Trip>> createTrip(TripDraft draft) async {
    final userId = _auth.currentUser?.id;
    if (userId == null) {
      return const Result.failure(
        Failure.auth(
          message: 'Your session has expired. Please sign in again.',
          code: 'AUTH_SESSION_EXPIRED',
        ),
      );
    }

    if (!_hasUnlimitedTrips()) {
      final activeCount = await _dao.countActiveTrips();
      if (activeCount >= _freeTierTripLimit) {
        return const Result.failure(
          Failure.quota(
            message: 'Free plan allows 3 active trips. Upgrade for unlimited.',
          ),
        );
      }
    }

    final now = _clock();
    final row = TripRow(
      id: _uuid.v4(),
      ownerId: userId,
      name: draft.name.trim(),
      destination: draft.destination,
      startDate: draft.startDate,
      endDate: draft.endDate,
      currency: draft.currency,
      totalBudgetMinor: draft.totalBudgetMinor,
      status: tripStatusToString(TripStatus.active),
      createdAt: now,
      updatedAt: now,
      version: 1,
      syncStatus: 'pending',
    );

    final result = await _commit(row, SyncOperation.create, action: 'createTrip');
    
    if (result.isSuccess) {
      await _dao.db.into(_dao.db.members).insert(
        MemberRow(
          id: _uuid.v4(),
          tripId: row.id,
          userId: userId,
          role: 'owner',
          status: 'active',
          joinedAt: now,
          updatedAt: now,
          syncStatus: 'synced', 
        ),
      );
    }
    
    return result;
  }

  @override
  Future<Result<Trip>> updateTrip(String id, TripDraft draft) async {
    final existing = await _dao.getTrip(id);
    if (existing == null) {
      return const Result.failure(Failure.unknown(message: 'Trip not found.'));
    }
    final row = existing.copyWith(
      name: draft.name.trim(),
      destination: Value(draft.destination),
      startDate: Value(draft.startDate),
      endDate: Value(draft.endDate),
      currency: draft.currency,
      totalBudgetMinor: Value(draft.totalBudgetMinor),
      updatedAt: _clock(),
      version: existing.version + 1,
      syncStatus: 'pending',
    );
    return _commit(row, SyncOperation.update, action: 'updateTrip');
  }

  @override
  Future<Result<Trip>> setArchived({
    required String id,
    required bool archived,
  }) async {
    final existing = await _dao.getTrip(id);
    if (existing == null) {
      return const Result.failure(Failure.unknown(message: 'Trip not found.'));
    }
    final row = existing.copyWith(
      status: tripStatusToString(
        archived ? TripStatus.archived : TripStatus.active,
      ),
      updatedAt: _clock(),
      version: existing.version + 1,
      syncStatus: 'pending',
    );
    return _commit(row, SyncOperation.update, action: 'setArchived');
  }

  @override
  Future<Result<void>> deleteTrip(String id) async {
    final existing = await _dao.getTrip(id);
    if (existing == null) {
      return const Result.success(null); // Idempotent.
    }
    final now = _clock();
    final row = existing.copyWith(
      status: tripStatusToString(TripStatus.deleted),
      deletedAt: Value(now),
      updatedAt: now,
      version: existing.version + 1,
      syncStatus: 'pending',
    );
    final result =
        await _commit(row, SyncOperation.delete, action: 'deleteTrip');
    return result.map((_) {});
  }

  @override
  Future<void> refreshFromRemote() async {
    if (_remoteSub != null) return;
    try {
      _remoteSub = _remote.watchTrips().listen(
            (dtos) => unawaited(_ingest(dtos.map(tripDtoToRow).toList())),
            onError: (Object error, StackTrace _) =>
                _logger.warning(_tag, 'realtime stream error: $error'),
          );
    } catch (error) {
      // Offline or unconfigured backend — reads continue from cache.
      _logger.warning(_tag, 'refreshFromRemote unavailable: $error');
    }
  }

  /// Persists [row] locally, enqueues [op] for sync, and triggers a drain.
  Future<Result<Trip>> _commit(
    TripRow row,
    SyncOperation op, {
    required String action,
  }) async {
    try {
      await _dao.upsertTrip(row);
      await _enqueue(op, row.id);
      unawaited(_syncEngine.requestSync());
      return Result.success(row.toEntity());
    } catch (error, stackTrace) {
      _logger.error(_tag, '$action failed',
          error: error, stackTrace: stackTrace);
      return const Result.failure(Failure.unknown());
    }
  }

  Future<void> _enqueue(SyncOperation op, String entityId) {
    return _queueDao.enqueue(
      SyncQueueItemsCompanion.insert(
        id: _uuid.v4(),
        entityType: SyncEntityType.trip,
        entityId: entityId,
        operation: op.name,
        payload: '{}',
        createdAt: _clock(),
      ),
    );
  }

  /// Cancels the realtime subscription. Called when the repository provider is
  /// disposed (CLAUDE.md §4).
  Future<void> dispose() async {
    await _remoteSub?.cancel();
    _remoteSub = null;
  }

  /// Upserts remote rows, preserving local rows that have unsynced edits newer
  /// than the incoming change (LWW + protect pending, Architecture §6).
  Future<void> _ingest(List<TripRow> remoteRows) async {
    for (final remote in remoteRows) {
      final local = await _dao.getTrip(remote.id);
      final localIsNewerPending = local != null &&
          local.syncStatus != 'synced' &&
          !remote.updatedAt.isAfter(local.updatedAt);
      if (localIsNewerPending) continue;
      await _dao.upsertTrip(remote);
    }
  }

  List<Trip> _toEntities(List<TripRow> rows) =>
      rows.map((row) => row.toEntity()).toList();
}
