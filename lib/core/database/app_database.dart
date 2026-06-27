import 'package:drift/drift.dart';
import 'package:tripmate/core/database/connection/native_connection.dart';
import 'package:tripmate/core/database/tables.dart';
import 'package:tripmate/core/sync/sync_queue_dao.dart';
import 'package:tripmate/features/expenses/data/datasources/expense_dao.dart';
import 'package:tripmate/features/members/data/datasources/member_dao.dart';
import 'package:tripmate/features/settlement/data/datasources/settlement_dao.dart';
import 'package:tripmate/features/trips/data/datasources/trip_dao.dart';

part 'app_database.g.dart';

/// The local offline-first database (Architecture §6). Source of truth for all
/// reads; writes land here first, then sync.
@DriftDatabase(
  tables: [Trips, Members, Expenses, ExpenseSplits, Settlements, SyncQueueItems],
  daos: [TripDao, MemberDao, ExpenseDao, SettlementDao, SyncQueueDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  /// In-memory database for tests.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(members);
          }
          if (from < 3) {
            await m.createTable(expenses);
            await m.createTable(expenseSplits);
          }
          if (from < 4) {
            await m.createTable(settlements);
          }
        },
      );
}
