import 'package:drift/drift.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/database/tables.dart';

part 'sync_queue_dao.g.dart';

/// Persists and drains the offline write queue (Architecture §6).
@DriftAccessor(tables: [SyncQueueItems])
class SyncQueueDao extends DatabaseAccessor<AppDatabase>
    with _$SyncQueueDaoMixin {
  SyncQueueDao(super.db);

  Future<void> enqueue(SyncQueueItemsCompanion item) {
    return into(syncQueueItems).insert(item);
  }

  /// Items that are due to be attempted now, oldest first (FIFO).
  Future<List<SyncQueueRow>> dueItems(DateTime now) {
    return (select(syncQueueItems)
          ..where(
            (t) =>
                t.nextAttemptAt.isSmallerOrEqualValue(now) |
                t.nextAttemptAt.isNull(),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<void> remove(String id) {
    return (delete(syncQueueItems)..where((t) => t.id.equals(id))).go();
  }

  Future<void> markFailed({
    required String id,
    required int attemptCount,
    required DateTime nextAttemptAt,
  }) {
    return (update(syncQueueItems)..where((t) => t.id.equals(id))).write(
      SyncQueueItemsCompanion(
        attemptCount: Value(attemptCount),
        nextAttemptAt: Value(nextAttemptAt),
        status: const Value('failed'),
      ),
    );
  }

  Future<int> pendingCount() async {
    final count = countAll();
    final query = selectOnly(syncQueueItems)..addColumns([count]);
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }
}
