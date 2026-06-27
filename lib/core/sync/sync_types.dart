/// The mutation an enqueued item represents (Architecture §6).
enum SyncOperation {
  create,
  update,
  delete;

  static SyncOperation fromName(String name) {
    return SyncOperation.values.firstWhere((op) => op.name == name);
  }
}

/// Entity-type keys used for dependency ordering and handler routing
/// (Architecture §6). Extended per feature (trip → member → expense → …).
abstract final class SyncEntityType {
  static const trip = 'trip';
  static const expense = 'expense';
  static const settlement = 'settlement';
}

/// Operation strings for expense sync items. Beyond create/update/delete,
/// expenses carry status transitions and a dependent receipt upload
/// (Architecture §6 ordering: expense → receipt).
abstract final class ExpenseSyncOp {
  static const create = 'create';
  static const update = 'update';
  static const delete = 'delete';
  static const approve = 'approve';
  static const reject = 'reject';
  static const receipt = 'receipt';
}

/// Operation strings for settlement sync items. v1.0 only persists completed
/// payments, so the single op records a paid settlement (Architecture §6,
/// CLAUDE.md §14 — idempotent by row id).
abstract final class SettlementSyncOp {
  static const markPaid = 'mark_paid';
}
