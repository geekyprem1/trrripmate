import 'package:drift/drift.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/database/tables.dart';

part 'settlement_dao.g.dart';

/// Local (Drift) access for settlements — completed payments are the read
/// source of truth (Architecture §6); outstanding transactions are computed.
@DriftAccessor(tables: [Settlements])
class SettlementDao extends DatabaseAccessor<AppDatabase>
    with _$SettlementDaoMixin {
  SettlementDao(super.db);

  /// Completed (non-deleted) payments for a trip — the settlement ledger.
  Stream<List<SettlementRow>> watchCompleted(String tripId) {
    return (select(settlements)
          ..where(
            (s) =>
                s.tripId.equals(tripId) &
                s.deletedAt.isNull() &
                s.status.equals('completed'),
          )
          ..orderBy([(s) => OrderingTerm.desc(s.completedAt)]))
        .watch();
  }

  Future<SettlementRow?> getSettlement(String id) {
    return (select(settlements)..where((s) => s.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsert(SettlementRow row) {
    return into(settlements).insertOnConflictUpdate(row);
  }

  Future<void> markSynced(String id, {required int version}) {
    return (update(settlements)..where((s) => s.id.equals(id))).write(
      SettlementsCompanion(
        syncStatus: const Value('synced'),
        version: Value(version),
      ),
    );
  }
}
