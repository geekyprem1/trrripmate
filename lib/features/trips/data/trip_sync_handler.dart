import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/sync/sync_handler.dart';
import 'package:tripmate/core/sync/sync_types.dart';
import 'package:tripmate/features/trips/data/datasources/trip_dao.dart';
import 'package:tripmate/features/trips/data/datasources/trip_remote_data_source.dart';
import 'package:tripmate/features/trips/data/mappers/trip_mappers.dart';

/// Pushes queued trip operations to the backend (Architecture §6).
///
/// Reads the current local row and pushes its latest state, so multiple edits
/// coalesce. Idempotent: create uses the row id as the idempotency key, and
/// re-running delete/update is safe (CLAUDE.md §14).
class TripSyncHandler implements SyncHandler {
  TripSyncHandler({
    required TripDao dao,
    required TripRemoteDataSource remote,
  })  : _dao = dao,
        _remote = remote;

  final TripDao _dao;
  final TripRemoteDataSource _remote;

  @override
  String get entityType => SyncEntityType.trip;

  @override
  Future<void> push(SyncQueueRow item) async {
    final row = await _dao.getTrip(item.entityId);
    if (row == null) return; // Nothing local to push.

    switch (SyncOperation.fromName(item.operation)) {
      case SyncOperation.create:
        final saved = await _remote.createTrip(row.toCreateParams());
        await _dao.markSynced(row.id, version: saved.version);
      case SyncOperation.update:
        final saved = await _remote.updateTrip(row.id, row.toUpdateFields());
        await _dao.markSynced(row.id, version: saved.version);
      case SyncOperation.delete:
        await _remote.deleteTrip(row.id);
        await _dao.markSynced(row.id, version: row.version);
    }
  }
}
