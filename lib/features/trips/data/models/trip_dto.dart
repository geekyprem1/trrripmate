import 'package:tripmate/features/trips/domain/entities/trip.dart';

/// Wire model for the server `trips` table (DB Design §4.2). The server stores
/// money as numeric **major** units; locally we use integer **minor** units, so
/// conversion happens here at the transport edge (CLAUDE.md §13).
class TripDto {
  const TripDto({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.currency,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.destination,
    this.startDate,
    this.endDate,
    this.totalBudgetMinor,
    this.deletedAt,
  });

  factory TripDto.fromJson(Map<String, dynamic> json) {
    return TripDto(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      currency: json['currency'] as String,
      status: json['status'] as String? ?? 'active',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      version: (json['version'] as num?)?.toInt() ?? 1,
      destination: json['destination'] as String?,
      startDate: _parseDate(json['start_date']),
      endDate: _parseDate(json['end_date']),
      totalBudgetMinor: _majorToMinor(json['total_budget']),
      deletedAt: _parseDate(json['deleted_at']),
    );
  }

  final String id;
  final String ownerId;
  final String name;
  final String currency;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final String? destination;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? totalBudgetMinor;
  final DateTime? deletedAt;

  Trip toEntity() {
    return Trip(
      id: id,
      ownerId: ownerId,
      name: name,
      currency: currency,
      status: _statusFromString(status),
      createdAt: createdAt,
      updatedAt: updatedAt,
      version: version,
      destination: destination,
      startDate: startDate,
      endDate: endDate,
      totalBudgetMinor: totalBudgetMinor,
    );
  }

  static int? _majorToMinor(Object? value) {
    if (value == null) return null;
    final asNum = value is num ? value : num.tryParse(value.toString());
    if (asNum == null) return null;
    return (asNum * 100).round();
  }

  static DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static TripStatus _statusFromString(String value) {
    return switch (value) {
      'archived' => TripStatus.archived,
      'deleted' => TripStatus.deleted,
      _ => TripStatus.active,
    };
  }
}
