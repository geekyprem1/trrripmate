import 'package:drift/drift.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/database/tables.dart';

part 'trip_dao.g.dart';

/// Local (Drift) access for trips — the read source of truth (Architecture §6).
@DriftAccessor(tables: [Trips])
class TripDao extends DatabaseAccessor<AppDatabase> with _$TripDaoMixin {
  TripDao(super.db);

  Stream<List<TripRow>> watchActiveTrips() {
    return (select(trips)
          ..where((t) => t.status.equals('active') & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  Stream<List<TripRow>> watchArchivedTrips() {
    return (select(trips)
          ..where((t) => t.status.equals('archived') & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  Stream<TripRow?> watchTrip(String id) {
    return (select(trips)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  Future<TripRow?> getTrip(String id) {
    return (select(trips)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Count of active (non-deleted) trips — used for the free-tier limit
  /// (PRD REQ-TRIP-01, DB Design §4.2 partial index).
  Future<int> countActiveTrips() async {
    final count = countAll();
    final query = selectOnly(trips)
      ..addColumns([count])
      ..where(trips.status.equals('active') & trips.deletedAt.isNull());
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<void> upsertTrip(TripRow row) {
    return into(trips).insertOnConflictUpdate(row);
  }

  Future<void> upsertAll(List<TripRow> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(trips, rows));
  }

  Future<void> markSynced(String id, {required int version}) {
    return (update(trips)..where((t) => t.id.equals(id))).write(
      TripsCompanion(
        syncStatus: const Value('synced'),
        version: Value(version),
      ),
    );
  }
}
