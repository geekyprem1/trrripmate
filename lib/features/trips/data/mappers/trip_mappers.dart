import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/features/trips/data/models/trip_dto.dart';
import 'package:tripmate/features/trips/domain/entities/trip.dart';

/// Mapping between Drift rows, DTOs, and the domain [Trip] (CLAUDE.md §5).
extension TripRowMapper on TripRow {
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
      syncState: _syncFromString(syncStatus),
      destination: destination,
      startDate: startDate,
      endDate: endDate,
      totalBudgetMinor: totalBudgetMinor,
    );
  }

  /// Remote RPC params for `create_trip` (API §4.1).
  Map<String, dynamic> toCreateParams() {
    return {
      'p_id': id,
      'p_name': name,
      'p_destination': destination,
      'p_start_date': _dateOnly(startDate),
      'p_end_date': _dateOnly(endDate),
      'p_currency': currency,
      'p_total_budget': _minorToMajorString(totalBudgetMinor),
      'p_idempotency_key': id,
    };
  }

  /// Column values for a PostgREST update / archive (API §3.2).
  Map<String, dynamic> toUpdateFields() {
    return {
      'name': name,
      'destination': destination,
      'start_date': _dateOnly(startDate),
      'end_date': _dateOnly(endDate),
      'currency': currency,
      'total_budget': _minorToMajorString(totalBudgetMinor),
      'status': status,
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'version': version,
    };
  }
}

/// Maps a server DTO into a local row (marked synced).
TripRow tripDtoToRow(TripDto dto) {
  return TripRow(
    id: dto.id,
    ownerId: dto.ownerId,
    name: dto.name,
    destination: dto.destination,
    startDate: dto.startDate,
    endDate: dto.endDate,
    currency: dto.currency,
    totalBudgetMinor: dto.totalBudgetMinor,
    status: dto.status,
    createdAt: dto.createdAt,
    updatedAt: dto.updatedAt,
    deletedAt: dto.deletedAt,
    version: dto.version,
    syncStatus: 'synced',
  );
}

String? _dateOnly(DateTime? date) {
  if (date == null) return null;
  final iso = date.toUtc().toIso8601String();
  return iso.substring(0, 10);
}

/// Money crosses the wire as a 2-dp string to avoid float drift (CLAUDE.md §13).
String? _minorToMajorString(int? minor) {
  if (minor == null) return null;
  final major = minor ~/ 100;
  final paise = (minor % 100).abs().toString().padLeft(2, '0');
  return '$major.$paise';
}

TripStatus _statusFromString(String value) {
  return switch (value) {
    'archived' => TripStatus.archived,
    'deleted' => TripStatus.deleted,
    _ => TripStatus.active,
  };
}

SyncState _syncFromString(String value) {
  return switch (value) {
    'pending' => SyncState.pending,
    'failed' => SyncState.failed,
    _ => SyncState.synced,
  };
}

/// String form of a [TripStatus] for storage/transport.
String tripStatusToString(TripStatus status) => status.name;
