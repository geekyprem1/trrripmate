import 'package:drift/drift.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/features/forecast/data/datasources/forecast_dao.dart';
import 'package:tripmate/features/forecast/domain/entities/forecast_item.dart';
import 'package:tripmate/features/forecast/domain/repositories/forecast_repository.dart';
import 'package:uuid/uuid.dart';

class ForecastRepositoryImpl implements ForecastRepository {
  ForecastRepositoryImpl(this._dao);

  final ForecastDao _dao;
  final _uuid = const Uuid();

  @override
  Stream<List<ForecastItem>> watchItems(String tripId) => _dao
      .watchByTrip(tripId)
      .map((rows) => [for (final r in rows) _rowToEntity(r)]);

  @override
  Future<void> addItem({
    required String tripId,
    required String name,
    required int amountMinor,
  }) =>
      _dao.insert(
        ForecastItemsCompanion.insert(
          id: _uuid.v4(),
          tripId: tripId,
          name: name,
          amountMinor: amountMinor,
          createdAt: DateTime.now(),
        ),
      );

  @override
  Future<void> deleteItem(String id) => _dao.deleteById(id);

  @override
  Future<void> clearAll(String tripId) => _dao.deleteAllForTrip(tripId);

  ForecastItem _rowToEntity(ForecastItemRow row) => ForecastItem(
        id: row.id,
        tripId: row.tripId,
        name: row.name,
        amountMinor: row.amountMinor,
        createdAt: row.createdAt,
      );
}
