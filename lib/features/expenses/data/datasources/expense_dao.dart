import 'package:drift/drift.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/database/tables.dart';

part 'expense_dao.g.dart';

/// Local (Drift) access for expenses and their splits — the read source of
/// truth (Architecture §6). Expense + splits are written in one transaction.
@DriftAccessor(tables: [Expenses, ExpenseSplits])
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  ExpenseDao(super.db);

  Stream<List<ExpenseRow>> watchExpenses(String tripId) {
    return (select(expenses)
          ..where((e) => e.tripId.equals(tripId) & e.deletedAt.isNull())
          ..orderBy([(e) => OrderingTerm.desc(e.expenseDate)]))
        .watch();
  }

  Stream<List<ExpenseRow>> watchPending(String tripId) {
    return (select(expenses)
          ..where(
            (e) =>
                e.tripId.equals(tripId) &
                e.deletedAt.isNull() &
                e.status.equals('pending'),
          )
          ..orderBy([(e) => OrderingTerm.desc(e.expenseDate)]))
        .watch();
  }

  Stream<ExpenseRow?> watchExpense(String id) {
    return (select(expenses)..where((e) => e.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<ExpenseRow?> getExpense(String id) {
    return (select(expenses)..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  Stream<List<ExpenseSplitRow>> watchSplits(String expenseId) {
    return (select(expenseSplits)..where((s) => s.expenseId.equals(expenseId)))
        .watch();
  }

  Future<List<ExpenseSplitRow>> getSplits(String expenseId) {
    return (select(expenseSplits)..where((s) => s.expenseId.equals(expenseId)))
        .get();
  }

  /// Approved (non-deleted) expenses for a trip — the settlement input set
  /// (PRD REQ-SET-01).
  Stream<List<ExpenseRow>> watchApprovedExpenses(String tripId) {
    return (select(expenses)
          ..where(
            (e) =>
                e.tripId.equals(tripId) &
                e.deletedAt.isNull() &
                e.status.equals('approved'),
          )
          ..orderBy([(e) => OrderingTerm.desc(e.expenseDate)]))
        .watch();
  }

  /// All split rows belonging to a trip's approved (non-deleted) expenses, in
  /// one join (avoids N+1 when computing balances).
  Future<List<ExpenseSplitRow>> getApprovedSplitsForTrip(String tripId) {
    final query = select(expenseSplits).join([
      innerJoin(expenses, expenses.id.equalsExp(expenseSplits.expenseId)),
    ])
      ..where(
        expenses.tripId.equals(tripId) &
            expenses.deletedAt.isNull() &
            expenses.status.equals('approved'),
      );
    return query.map((row) => row.readTable(expenseSplits)).get();
  }

  /// Reactive sum of approved (non-deleted) expense amounts — feeds the budget
  /// (PRD REQ-BUD-01).
  Stream<int> watchApprovedSpentMinor(String tripId) {
    final sum = expenses.amountMinor.sum();
    final query = selectOnly(expenses)
      ..addColumns([sum])
      ..where(
        expenses.tripId.equals(tripId) &
            expenses.deletedAt.isNull() &
            expenses.status.equals('approved'),
      );
    return query.watchSingle().map((row) => row.read(sum) ?? 0);
  }

  /// Writes an expense and its splits atomically (replacing prior splits).
  Future<void> upsertWithSplits(
    ExpenseRow expense,
    List<ExpenseSplitRow> splits,
  ) async {
    await transaction(() async {
      await into(expenses).insertOnConflictUpdate(expense);
      await (delete(expenseSplits)
            ..where((s) => s.expenseId.equals(expense.id)))
          .go();
      await batch((b) => b.insertAll(expenseSplits, splits));
    });
  }

  /// Upserts only the expense row (leaves splits untouched) — for soft delete
  /// and status changes.
  Future<void> upsertExpenseOnly(ExpenseRow expense) {
    return into(expenses).insertOnConflictUpdate(expense);
  }

  Future<void> markSynced(String id, {required int version}) {
    return (update(expenses)..where((e) => e.id.equals(id))).write(
      ExpensesCompanion(
        syncStatus: const Value('synced'),
        version: Value(version),
      ),
    );
  }

  Future<void> updateReceipt(
    String id, {
    required String storagePath,
    required String status,
  }) {
    return (update(expenses)..where((e) => e.id.equals(id))).write(
      ExpensesCompanion(
        receiptStoragePath: Value(storagePath),
        receiptUploadStatus: Value(status),
      ),
    );
  }
}
