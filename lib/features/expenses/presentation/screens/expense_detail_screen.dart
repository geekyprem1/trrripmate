import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripmate/app/router/app_routes.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/core/widgets/app_state_views.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/expenses/data/expense_providers.dart';
import 'package:tripmate/features/expenses/domain/entities/expense.dart';
import 'package:tripmate/features/expenses/presentation/category_icons.dart';
import 'package:tripmate/features/expenses/presentation/controllers/expense_actions_controller.dart';
import 'package:tripmate/features/members/data/member_providers.dart';

/// Expense detail with splits, receipt, and owner/author actions (UI/UX §3.10).
class ExpenseDetailScreen extends ConsumerWidget {
  const ExpenseDetailScreen({required this.expenseId, super.key});

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
        return _DetailView(expense: expense);
      },
    );
  }
}

class _DetailView extends ConsumerWidget {
  const _DetailView({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final members =
        ref.watch(tripMembersProvider(expense.tripId)).valueOrNull ?? [];
    final names = {for (final m in members) m.id: m.displayName ?? 'Member'};
    final userId = ref.watch(authStateProvider).valueOrNull?.id;
    final isOwner = members.any((m) => m.userId == userId && m.isOwner);
    final isAuthor = expense.createdBy == userId;

    return Scaffold(
      appBar: AppBar(
        title: Text(expense.category.label),
        actions: [
          if (isOwner || isAuthor)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit',
              onPressed: () => context.pushNamed(
                AppRoutes.editExpenseName,
                pathParameters: {'id': expense.tripId, 'eid': expense.id},
              ),
            ),
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: () => _confirmDelete(context, ref),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  foregroundColor: theme.colorScheme.onSecondaryContainer,
                  child: Icon(categoryIcon(expense.category)),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  Money.format(expense.amountMinor, expense.currency),
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  'Paid by ${names[expense.paidByMemberId] ?? 'Member'} · '
                  '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (expense.description != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(expense.description!, style: theme.textTheme.bodyLarge),
          ],
          const SizedBox(height: AppSpacing.lg),
          if (expense.status == ExpenseStatus.pending && isOwner)
            _ApprovalActions(expense: expense),
          const SizedBox(height: AppSpacing.lg),
          Text('Split', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          for (final split in expense.splits)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(names[split.memberId] ?? 'Member'),
              trailing: Text(
                Money.format(split.shareMinor, expense.currency),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          if (expense.hasReceipt) ...[
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: () => _viewReceipt(context, ref),
              icon: const Icon(Icons.receipt_long_outlined),
              label: const Text('View receipt'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete expense?'),
        content: const Text('You can restore it within 30 days.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!(confirmed ?? false)) return;
    final failure = await ref
        .read(expenseActionsControllerProvider.notifier)
        .delete(expense.id);
    if (!context.mounted) return;
    if (failure == null) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failure.displayMessage)));
    }
  }

  Future<void> _viewReceipt(BuildContext context, WidgetRef ref) async {
    final result =
        await ref.read(expenseRepositoryProvider).receiptUrl(expense.id);
    if (!context.mounted) return;
    result.fold(
      onSuccess: (url) => showDialog<void>(
        context: context,
        builder: (_) => Dialog(
          child: InteractiveViewer(
            child: url.startsWith('http')
                ? Image.network(url)
                : Image.asset(url,
                    errorBuilder: (_, __, ___) => const SizedBox()),
          ),
        ),
      ),
      onFailure: (failure) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failure.displayMessage))),
    );
  }
}

class _ApprovalActions extends ConsumerWidget {
  const _ApprovalActions({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> act(ExpenseStatus status) async {
      final failure = await ref
          .read(expenseActionsControllerProvider.notifier)
          .setStatus(expense.id, status);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              failure?.displayMessage ??
                  (status == ExpenseStatus.approved ? 'Approved' : 'Rejected'),
            ),
          ),
        );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => act(ExpenseStatus.rejected),
            child: const Text('Reject'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: FilledButton(
            onPressed: () => act(ExpenseStatus.approved),
            child: const Text('Approve'),
          ),
        ),
      ],
    );
  }
}
