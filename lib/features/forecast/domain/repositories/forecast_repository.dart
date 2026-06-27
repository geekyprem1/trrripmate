import 'package:tripmate/features/forecast/domain/entities/forecast_item.dart';

abstract interface class ForecastRepository {
  Stream<List<ForecastItem>> watchItems(String tripId);
  Future<void> addItem({
    required String tripId,
    required String name,
    required int amountMinor,
  });
  Future<void> deleteItem(String id);
  Future<void> clearAll(String tripId);
}
