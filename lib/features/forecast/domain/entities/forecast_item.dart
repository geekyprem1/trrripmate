import 'package:freezed_annotation/freezed_annotation.dart';

part 'forecast_item.freezed.dart';

@freezed
class ForecastItem with _$ForecastItem {
  const factory ForecastItem({
    required String id,
    required String tripId,
    required String name,
    required int amountMinor,
    required DateTime createdAt,
  }) = _ForecastItem;
}
