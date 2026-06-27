import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/features/expenses/data/expense_providers.dart';
import 'package:tripmate/features/expenses/domain/entities/expense.dart';

part 'expense_actions_controller.g.dart';

/// Delete / approve / reject actions (UI/UX §3.10/§3.11). Returns the [Failure]
/// on error (null on success) while the list/detail updates reactively.
@riverpod
class ExpenseActionsController extends _$ExpenseActionsController {
  @override
  Future<void> build() async {}

  Future<Failure?> delete(String expenseId) async {
    final result =
        await ref.read(expenseRepositoryProvider).deleteExpense(expenseId);
    return result.failureOrNull;
  }

  Future<Failure?> setStatus(String expenseId, ExpenseStatus status) async {
    final result = await ref
        .read(expenseRepositoryProvider)
        .setStatus(expenseId: expenseId, status: status);
    return result.failureOrNull;
  }
}
