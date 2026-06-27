import 'package:tripmate/core/error/result.dart';
import 'package:tripmate/features/expenses/domain/entities/expense.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';

/// Parameters for creating or editing an expense (PRD REQ-EXP-01/02).
class ExpenseDraft {
  const ExpenseDraft({
    required this.amountMinor,
    required this.category,
    required this.paidByMemberId,
    required this.splitMemberIds,
    required this.date,
    this.description,
    this.receiptLocalPath,
  });

  final int amountMinor;
  final ExpenseCategory category;
  final String paidByMemberId;
  final List<String> splitMemberIds;
  final DateTime date;
  final String? description;

  /// A freshly captured receipt to upload, if any.
  final String? receiptLocalPath;
}

/// Domain boundary for expenses (PRD REQ-EXP-01..06, API §4.3-§4.6).
///
/// Reads stream from the local store; writes commit locally and return before
/// syncing (CLAUDE.md §5/§14). No exceptions cross this boundary.
abstract interface class ExpenseRepository {
  /// All non-deleted expenses for a trip, newest first.
  Stream<List<Expense>> watchExpenses(String tripId);

  /// Pending expenses awaiting owner approval (Approval Queue, REQ-EXP-04).
  Stream<List<Expense>> watchPending(String tripId);

  /// A single expense with its splits.
  Stream<Expense?> watchExpense(String expenseId);

  /// Reactive sum of approved expense amounts in minor units (PRD REQ-BUD-01).
  Stream<int> watchApprovedSpentMinor(String tripId);

  /// Approved (non-deleted) expenses with their splits attached — the input to
  /// settlement balance computation (PRD REQ-SET-01). Reactive.
  Stream<List<Expense>> watchApprovedWithSplits(String tripId);

  /// Creates an expense + splits locally and queues it for sync.
  Future<Result<Expense>> createExpense({
    required String tripId,
    required String currency,
    required ExpenseDraft draft,
  });

  /// Edits an expense (author or owner). Material changes revert an approved
  /// expense to pending (REQ-EXP-02).
  Future<Result<Expense>> updateExpense({
    required String expenseId,
    required ExpenseDraft draft,
  });

  /// Soft-deletes an expense (owner) (REQ-EXP-03).
  Future<Result<void>> deleteExpense(String expenseId);

  /// Approves or rejects a pending expense (owner) (REQ-EXP-04).
  Future<Result<Expense>> setStatus({
    required String expenseId,
    required ExpenseStatus status,
  });

  /// Issues a short-lived signed URL for an uploaded receipt (Architecture §10).
  Future<Result<String>> receiptUrl(String expenseId);

  /// Pulls expenses from the backend into the cache and keeps it in sync via
  /// realtime (Architecture §9). Safe to call offline.
  Future<void> refreshFromRemote(String tripId);
}
