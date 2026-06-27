import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';

part 'expense.freezed.dart';

/// Expense approval status (DB Design §4.5).
enum ExpenseStatus { pending, approved, rejected }

/// Local sync state (Drift-only, DB Design §8).
enum ExpenseSyncState { synced, pending, failed }

/// Receipt upload state for an attached image (Architecture §10).
enum ReceiptStatus { none, pending, uploaded, failed }

/// One member's share of an expense (DB Design §4.6).
@freezed
class ExpenseSplit with _$ExpenseSplit {
  const factory ExpenseSplit({
    required String memberId,
    required int shareMinor,
  }) = _ExpenseSplit;
}

/// An expense with its splits (DB Design §4.5/§4.6). Money is integer minor
/// units; the splits always sum to [amountMinor].
@freezed
class Expense with _$Expense {
  const factory Expense({
    required String id,
    required String tripId,
    required String paidByMemberId,
    required int amountMinor,
    required String currency,
    required ExpenseCategory category,
    required DateTime date,
    required ExpenseStatus status,
    required String createdBy,
    @Default(<ExpenseSplit>[]) List<ExpenseSplit> splits,
    @Default(ExpenseSyncState.synced) ExpenseSyncState syncState,
    @Default(ReceiptStatus.none) ReceiptStatus receiptStatus,
    String? description,
    String? receiptLocalPath,
    String? receiptStoragePath,
    @Default(1) int version,
  }) = _Expense;

  const Expense._();

  bool get isPendingSync => syncState != ExpenseSyncState.synced;

  bool get hasReceipt => receiptStatus != ReceiptStatus.none;

  bool get isApproved => status == ExpenseStatus.approved;
}
