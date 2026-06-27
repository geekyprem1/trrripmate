import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/features/expenses/data/expense_providers.dart';
import 'package:tripmate/features/expenses/domain/repositories/expense_repository.dart';

part 'expense_form_controller.g.dart';

/// Drives the Add / Edit Expense form (UI/UX §3.9). Holds the submit
/// [AsyncValue]; returns `true` so the screen can pop on success. The screen
/// disables the button while loading to debounce duplicate taps (REQ-EXP-01).
@riverpod
class ExpenseFormController extends _$ExpenseFormController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> submit({
    required String tripId,
    required String currency,
    required ExpenseDraft draft,
    String? expenseId,
  }) async {
    state = const AsyncValue.loading();
    final repo = ref.read(expenseRepositoryProvider);
    final result = expenseId == null
        ? await repo.createExpense(
            tripId: tripId,
            currency: currency,
            draft: draft,
          )
        : await repo.updateExpense(expenseId: expenseId, draft: draft);
    return result.fold(
      onSuccess: (_) {
        state = const AsyncValue.data(null);
        return true;
      },
      onFailure: (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
    );
  }
}
