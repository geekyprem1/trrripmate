import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip.freezed.dart';

/// Trip lifecycle status (DB Design §4.2).
enum TripStatus { active, archived, deleted }

/// Local sync state of an entity (DB Design §8, Drift-only).
enum SyncState { synced, pending, failed }

/// A trip aggregate root (DB Design §4.2). Money is in integer minor units.
@freezed
class Trip with _$Trip {
  const factory Trip({
    required String id,
    required String ownerId,
    required String name,
    required String currency,
    required TripStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(1) int version,
    @Default(SyncState.synced) SyncState syncState,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    int? totalBudgetMinor,
  }) = _Trip;

  const Trip._();

  /// Whether this trip has unsynced local changes.
  bool get isPendingSync => syncState != SyncState.synced;

  /// Whether a budget has been set.
  bool get hasBudget => totalBudgetMinor != null;
}
