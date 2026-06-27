import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/sync/sync_handler.dart';
import 'package:tripmate/core/sync/sync_types.dart';
import 'package:tripmate/features/expenses/data/datasources/expense_dao.dart';
import 'package:tripmate/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:tripmate/features/expenses/data/datasources/receipt_remote_data_source.dart';
import 'package:tripmate/features/expenses/data/mappers/expense_mappers.dart';

/// Pushes queued expense operations to the backend (Architecture §6).
///
/// Reads the current local row + splits and pushes the latest state, so edits
/// coalesce. Create uses the row id as the idempotency key; status changes use
/// the dedicated RPC; the receipt upload is a dependent op enqueued after the
/// expense (expense → receipt ordering). Idempotent (CLAUDE.md §14).
class ExpenseSyncHandler implements SyncHandler {
  ExpenseSyncHandler({
    required ExpenseDao dao,
    required ExpenseRemoteDataSource remote,
    required ReceiptRemoteDataSource receipts,
  })  : _dao = dao,
        _remote = remote,
        _receipts = receipts;

  final ExpenseDao _dao;
  final ExpenseRemoteDataSource _remote;
  final ReceiptRemoteDataSource _receipts;

  @override
  String get entityType => SyncEntityType.expense;

  @override
  Future<void> push(SyncQueueRow item) async {
    final row = await _dao.getExpense(item.entityId);
    if (row == null) return;

    switch (item.operation) {
      case ExpenseSyncOp.create:
        final splits = await _dao.getSplits(row.id);
        final saved = await _remote.createExpense(row.toCreateParams(splits));
        await _dao.markSynced(row.id, version: saved.version);
      case ExpenseSyncOp.update:
        final splits = await _dao.getSplits(row.id);
        final saved = await _remote.updateExpense(row.toUpdateParams(splits));
        await _dao.markSynced(row.id, version: saved.version);
      case ExpenseSyncOp.delete:
        await _remote.deleteExpense(row.id);
        await _dao.markSynced(row.id, version: row.version);
      case ExpenseSyncOp.approve:
        final saved = await _remote.setStatus(row.id, 'approved');
        await _dao.markSynced(row.id, version: saved.version);
      case ExpenseSyncOp.reject:
        final saved = await _remote.setStatus(row.id, 'rejected');
        await _dao.markSynced(row.id, version: saved.version);
      case ExpenseSyncOp.receipt:
        await _pushReceipt(row);
    }
  }

  Future<void> _pushReceipt(ExpenseRow row) async {
    final localPath = row.receiptLocalPath;
    if (localPath == null) return;
    final objectPath = await _receipts.upload(
      tripId: row.tripId,
      expenseId: row.id,
      localPath: localPath,
    );
    await _remote.setReceipt(row.id, objectPath);
    await _dao.updateReceipt(
      row.id,
      storagePath: objectPath,
      status: 'uploaded',
    );
  }
}
