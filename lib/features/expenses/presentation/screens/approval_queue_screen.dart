import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripmate/app/router/app_routes.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/widgets/app_state_views.dart';
import 'package:tripmate/features/expenses/data/expense_providers.dart';
import 'package:tripmate/features/expenses/domain/entities/expense.dart';
import 'package:tripmate/features/expenses/presentation/controllers/expense_actions_controller.dart';
import 'package:tripmate/features/expenses/presentation/widgets/expense_tile.dart';
import 'package:tripmate/features/members/data/member_providers.dart';

/// Owner Approval Queue (UI/UX §3.11, PRD REQ-EXP-04).
class ApprovalQueueScreen extends ConsumerWidget {
  const ApprovalQueueScreen({required this.tripId, super.key});

  final String tripId;

  Future<void> _act(
    BuildContext context,
    WidgetRef ref,
    String expenseId,
    ExpenseStatus status,
  ) async {
    final failure = await ref
        .read(expenseActionsControllerProvider.notifier)
        .setStatus(expenseId, status);
    if (!context.mounted || failure == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(failure.displayMessage)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingExpensesProvider(tripId));
    final members = ref.watch(tripMembersProvider(tripId)).valueOrNull ?? [];
    final names = {for (final m in members) m.id: m.displayName ?? 'Member'};

    return Scaffold(
      appBar: AppBar(title: const Text('Approvals')),
      body: pendingAsync.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(
          message: error is Failure ? error.displayMessage : 'Failed to load.',
        ),
        data: (pending) {
          if (pending.isEmpty) {
            return const AppEmptyView(
              icon: Icons.task_alt,
              message: 'All caught up — no expenses awaiting approval.',
            );
          }
          return ListView.builder(
            itemCount: pending.length,
            itemBuilder: (context, index) {
              final expense = pending[index];
              return Column(
                children: [
                  ExpenseTile(
                    expense: expense,
                    payerName: names[expense.paidByMemberId],
                    onTap: () => context.pushNamed(
                      AppRoutes.expenseDetailName,
                      pathParameters: {'id': tripId, 'eid': expense.id},
                    ),
                  ),
                  OverflowBar(
                    alignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _act(
                          context,
                          ref,
                          expense.id,
                          ExpenseStatus.rejected,
                        ),
                        child: const Text('Reject'),
                      ),
                      FilledButton(
                        onPressed: () => _act(
                          context,
                          ref,
                          expense.id,
                          ExpenseStatus.approved,
                        ),
                        child: const Text('Approve'),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const Divider(height: 1),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
