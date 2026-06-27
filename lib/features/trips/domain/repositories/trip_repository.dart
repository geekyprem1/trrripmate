import 'package:tripmate/core/error/result.dart';
import 'package:tripmate/features/trips/domain/entities/trip.dart';

/// Parameters for creating or editing a trip (PRD REQ-TRIP-01/02).
class TripDraft {
  const TripDraft({
    required this.name,
    required this.currency,
    this.destination,
    this.startDate,
    this.endDate,
    this.totalBudgetMinor,
  });

  final String name;
  final String currency;
  final String? destination;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? totalBudgetMinor;
}

/// Domain boundary for trips (PRD REQ-TRIP-01..04, API §3.2/§4).
///
/// Reads stream from the local store (offline-first); writes commit locally and
/// return before syncing (CLAUDE.md §5/§14). No exceptions cross this boundary.
abstract interface class TripRepository {
  /// Active (non-archived, non-deleted) trips, newest first.
  Stream<List<Trip>> watchActiveTrips();

  /// Archived trips, newest first.
  Stream<List<Trip>> watchArchivedTrips();

  /// A single trip by id (null if absent).
  Stream<Trip?> watchTrip(String id);

  /// Creates a trip locally and queues it for sync. Enforces the free-tier
  /// active-trip limit (PRD REQ-TRIP-01).
  Future<Result<Trip>> createTrip(TripDraft draft);

  /// Edits an existing trip (PRD REQ-TRIP-02).
  Future<Result<Trip>> updateTrip(String id, TripDraft draft);

  /// Archives or unarchives a trip (PRD REQ-TRIP-04).
  Future<Result<Trip>> setArchived(
      {required String id, required bool archived});

  /// Soft-deletes a trip (PRD REQ-TRIP-03).
  Future<Result<void>> deleteTrip(String id);

  /// Pulls the user's trips from the backend into the local store and keeps it
  /// in sync via realtime (Architecture §9). Safe to call when offline.
  Future<void> refreshFromRemote();
}
