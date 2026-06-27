import 'package:drift/drift.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/database/tables.dart';

part 'forecast_dao.g.dart';

@DriftAccessor(tables: [ForecastItems])
class ForecastDao extends DatabaseAccessor<AppDatabase>
    with _$ForecastDaoMixin {
  ForecastDao(super.db);

  Stream<List<ForecastItemRow>> watchByTrip(String tripId) =>
      (select(forecastItems)
            ..where((t) => t.tripId.equals(tripId))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch();

  Future<void> insert(ForecastItemsCompanion row) =>
      into(forecastItems).insert(row);

  Future<void> deleteById(String id) =>
      (delete(forecastItems)..where((t) => t.id.equals(id))).go();

  Future<void> deleteAllForTrip(String tripId) =>
      (delete(forecastItems)..where((t) => t.tripId.equals(tripId))).go();
}
