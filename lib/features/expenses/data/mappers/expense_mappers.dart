import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/features/expenses/data/models/expense_dto.dart';
import 'package:tripmate/features/expenses/domain/entities/expense.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';

/// Mapping between Drift rows, DTOs, and the domain [Expense] (CLAUDE.md §5).
extension ExpenseRowMapper on ExpenseRow {
  Expense toEntity(List<ExpenseSplitRow> splitRows) {
    return Expense(
      id: id,
      tripId: tripId,
      paidByMemberId: paidByMemberId,
      amountMinor: amountMinor,
      currency: currency,
      category: ExpenseCategory.fromName(category),
      date: expenseDate,
      status: expenseStatusFromString(status),
      createdBy: createdBy,
      splits: splitRows
          .map((s) =>
              ExpenseSplit(memberId: s.memberId, shareMinor: s.shareMinor))
          .toList(),
      syncState: _syncStateFromString(syncStatus),
      receiptStatus: _receiptStatus(this),
      description: description,
      receiptLocalPath: receiptLocalPath,
      receiptStoragePath: receiptStoragePath,
      version: version,
    );
  }

  /// Params for the `create_expense` RPC (API §4.3).
  Map<String, dynamic> toCreateParams(List<ExpenseSplitRow> splits) {
    return {
      'p_id': id,
      'p_trip_id': tripId,
      'p_paid_by': paidByMemberId,
      'p_amount': Money.minorToMajorString(amountMinor),
      'p_currency': currency,
      'p_category': category,
      'p_description': description,
      'p_expense_date': expenseDate.toUtc().toIso8601String(),
      'p_status': status,
      'p_split_type': splitType,
      'p_splits': _splitParams(splits),
      'p_idempotency_key': id,
    };
  }

  /// Params for the `update_expense` RPC (API §4.4).
  Map<String, dynamic> toUpdateParams(List<ExpenseSplitRow> splits) {
    return {
      'p_id': id,
      'p_amount': Money.minorToMajorString(amountMinor),
      'p_category': category,
      'p_description': description,
      'p_expense_date': expenseDate.toUtc().toIso8601String(),
      'p_splits': _splitParams(splits),
      'p_expected_version': version - 1,
    };
  }

  List<Map<String, dynamic>> _splitParams(List<ExpenseSplitRow> splits) {
    return [
      for (final s in splits)
        {
          'member_id': s.memberId,
          'share_amount': Money.minorToMajorString(s.shareMinor),
        },
    ];
  }
}

ExpenseRow expenseDtoToRow(ExpenseDto dto) {
  return ExpenseRow(
    id: dto.id,
    tripId: dto.tripId,
    paidByMemberId: dto.paidByMemberId,
    amountMinor: dto.amountMinor,
    currency: dto.currency,
    category: dto.category,
    description: dto.description,
    expenseDate: dto.expenseDate,
    status: dto.status,
    splitType: dto.splitType,
    receiptStoragePath: dto.receiptStoragePath,
    receiptUploadStatus: dto.receiptStoragePath != null ? 'uploaded' : null,
    createdBy: dto.createdBy,
    createdAt: dto.updatedAt,
    updatedAt: dto.updatedAt,
    deletedAt: dto.deletedAt,
    version: dto.version,
    syncStatus: 'synced',
  );
}

List<ExpenseSplitRow> splitDtosToRows(ExpenseDto dto) {
  return [
    for (final s in dto.splits)
      ExpenseSplitRow(
        id: '${dto.id}:${s.memberId}',
        expenseId: dto.id,
        memberId: s.memberId,
        shareMinor: s.shareMinor,
      ),
  ];
}

ExpenseStatus expenseStatusFromString(String value) {
  return switch (value) {
    'pending' => ExpenseStatus.pending,
    'rejected' => ExpenseStatus.rejected,
    _ => ExpenseStatus.approved,
  };
}

String expenseStatusToString(ExpenseStatus status) => status.name;

ExpenseSyncState _syncStateFromString(String value) {
  return switch (value) {
    'pending' => ExpenseSyncState.pending,
    'failed' => ExpenseSyncState.failed,
    _ => ExpenseSyncState.synced,
  };
}

ReceiptStatus _receiptStatus(ExpenseRow row) {
  if (row.receiptUploadStatus == null &&
      row.receiptLocalPath == null &&
      row.receiptStoragePath == null) {
    return ReceiptStatus.none;
  }
  return switch (row.receiptUploadStatus) {
    'uploaded' => ReceiptStatus.uploaded,
    'failed' => ReceiptStatus.failed,
    'pending' => ReceiptStatus.pending,
    _ => row.receiptStoragePath != null
        ? ReceiptStatus.uploaded
        : ReceiptStatus.pending,
  };
}
