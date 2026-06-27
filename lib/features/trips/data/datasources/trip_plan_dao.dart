import 'package:drift/drift.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/database/tables.dart';

part 'trip_plan_dao.g.dart';

@DriftAccessor(tables: [TripPlanItems])
class TripPlanDao extends DatabaseAccessor<AppDatabase>
    with _$TripPlanDaoMixin {
  TripPlanDao(super.db);

  Stream<List<TripPlanItemRow>> watchByTrip(String tripId) =>
      (select(tripPlanItems)
            ..where((t) => t.tripId.equals(tripId))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch();

  Future<void> insert(TripPlanItemsCompanion row) =>
      into(tripPlanItems).insert(row);

  Future<void> updateItem(TripPlanItemsCompanion row) =>
      (update(tripPlanItems)..where((t) => t.id.equals(row.id.value)))
          .write(row);

  Future<void> deleteById(String id) =>
      (delete(tripPlanItems)..where((t) => t.id.equals(id))).go();

  Future<void> deleteAllForTrip(String tripId) =>
      (delete(tripPlanItems)..where((t) => t.tripId.equals(tripId))).go();
}
