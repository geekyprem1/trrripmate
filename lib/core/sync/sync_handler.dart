import 'package:tripmate/core/database/app_database.dart';

/// Pushes one queued operation to the backend for a given entity type
/// (Architecture §6). Each feature registers its own handler with the engine.
///
/// Implementations should be idempotent — the same item may be retried
/// (CLAUDE.md §14). Throwing signals a retryable failure to the engine.
abstract interface class SyncHandler {
  /// The `SyncEntityType` this handler is responsible for.
  String get entityType;

  /// Pushes the queued [item] to the backend. On success the engine removes
  /// it from the queue; on throw the engine schedules a retry.
  Future<void> push(SyncQueueRow item);
}
