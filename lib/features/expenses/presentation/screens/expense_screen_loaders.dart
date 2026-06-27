import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/widgets/app_state_views.dart';
import 'package:tripmate/features/expenses/data/expense_providers.dart';
import 'package:tripmate/features/expenses/presentation/screens/add_edit_expense_screen.dart';
import 'package:tripmate/features/trips/data/trip_providers.dart';

/// Resolves the trip's currency, then shows the Add Expense form (handles deep
/// links without passing navigation args).
class AddExpenseLoader extends ConsumerWidget {
  const AddExpenseLoader({required this.tripId, super.key});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(tripByIdProvider(tripId));
    return tripAsync.when(
      loading: () => const Scaffold(body: AppLoadingView()),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: AppErrorView(
          message: error is Failure ? error.displayMessage : 'Failed to load.',
        ),
      ),
      data: (trip) {
        if (trip == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const AppEmptyView(message: 'Trip not found.'),
          );
        }
        return AddEditExpenseScreen(tripId: tripId, currency: trip.currency);
      },
    );
  }
}

/// Resolves the expense, then shows the Edit form.
class EditExpenseLoader extends ConsumerWidget {
  const EditExpenseLoader({required this.expenseId, super.key});

  final String expenseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseAsync = ref.watch(expenseByIdProvider(expenseId));
    return expenseAsync.when(
      loading: () => const Scaffold(body: AppLoadingView()),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: AppErrorView(
          message: error is Failure ? error.displayMessage : 'Failed to load.',
        ),
      ),
      data: (expense) {
        if (expense == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const AppEmptyView(message: 'Expense not found.'),
          );
        }
        return AddEditExpenseScreen(
          tripId: expense.tripId,
          currency: expense.currency,
          expense: expense,
        );
      },
    );
  }
}
