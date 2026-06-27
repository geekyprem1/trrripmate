import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripmate/app/router/app_routes.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/widgets/app_state_views.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/expenses/data/expense_providers.dart';
import 'package:tripmate/features/expenses/domain/entities/expense.dart';
import 'package:tripmate/features/expenses/presentation/widgets/expense_tile.dart';
import 'package:tripmate/features/members/data/member_providers.dart';

/// The Expenses tab inside the trip dashboard (UI/UX §3.8).
class ExpensesTab extends ConsumerWidget {
  const ExpensesTab({required this.tripId, super.key});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(tripExpensesProvider(tripId));
    final members = ref.watch(tripMembersProvider(tripId)).valueOrNull ?? [];
    final pending =
        ref.watch(pendingExpensesProvider(tripId)).valueOrNull ?? [];
    final userId = ref.watch(authStateProvider).valueOrNull?.id;
    final isOwner = members.any((m) => m.userId == userId && m.isOwner);
    final names = {for (final m in members) m.id: m.displayName ?? 'Member'};

    return expensesAsync.when(
      loading: () => const AppLoadingView(),
      error: (error, _) => AppErrorView(
        message: error is Failure ? error.displayMessage : 'Failed to load.',
        onRetry: () => ref.invalidate(tripExpensesProvider(tripId)),
      ),
      data: (expenses) {
        if (expenses.isEmpty) {
          return const AppEmptyView(
            icon: Icons.receipt_long_outlined,
            message: 'No expenses yet.\nAdd your first to start tracking.',
          );
        }
        final showBanner = isOwner && pending.isNotEmpty;
        final itemCount = expenses.length + (showBanner ? 1 : 0);

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: AppSpacing.huge),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (showBanner && index == 0) {
              return _ApprovalBanner(
                count: pending.length,
                onTap: () => context.pushNamed(
                  AppRoutes.approvalsName,
                  pathParameters: {'id': tripId},
                ),
              );
            }
            final expenseIndex = showBanner ? index - 1 : index;
            final expense = expenses[expenseIndex];
            return ExpenseTile(
              expense: expense,
              payerName: names[expense.paidByMemberId],
              onTap: () => context.pushNamed(
                AppRoutes.expenseDetailName,
                pathParameters: {'id': tripId, 'eid': expense.id},
              ),
            );
          },
        );
      },
    );
  }
}

class _ApprovalBanner extends StatelessWidget {
  const _ApprovalBanner({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: ListTile(
        leading: const Icon(Icons.fact_check_outlined),
        title: Text('$count expense(s) awaiting approval'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

/// Helper for grouping (kept simple in v1.0 — flat newest-first list).
List<Expense> sortedByDateDesc(List<Expense> expenses) {
  final copy = [...expenses]..sort((a, b) => b.date.compareTo(a.date));
  return copy;
}
