import 'package:tripmate/core/utils/money.dart';

/// Wire model for a `settlements` row (DB Design §4.7). Money crosses as numeric
/// major units; locally we use integer minor units.
class SettlementDto {
  const SettlementDto({
    required this.id,
    required this.tripId,
    required this.fromMemberId,
    required this.toMemberId,
    required this.amountMinor,
    required this.status,
    required this.version,
    required this.updatedAt,
    this.markedByMemberId,
    this.completedAt,
    this.deletedAt,
  });

  factory SettlementDto.fromJson(Map<String, dynamic> json) {
    return SettlementDto(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      fromMemberId: json['from_member_id'] as String,
      toMemberId: json['to_member_id'] as String,
      amountMinor: Money.majorToMinor(json['amount']) ?? 0,
      status: json['status'] as String? ?? 'completed',
      version: (json['version'] as num?)?.toInt() ?? 1,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      markedByMemberId: json['marked_by'] as String?,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.tryParse(json['completed_at'].toString()),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.tryParse(json['deleted_at'].toString()),
    );
  }

  final String id;
  final String tripId;
  final String fromMemberId;
  final String toMemberId;
  final int amountMinor;
  final String status;
  final int version;
  final DateTime updatedAt;
  final String? markedByMemberId;
  final DateTime? completedAt;
  final DateTime? deletedAt;
}
