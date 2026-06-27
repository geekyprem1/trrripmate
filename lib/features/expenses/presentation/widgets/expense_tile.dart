import 'package:flutter/material.dart';
import 'package:tripmate/app/theme/app_colors.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/features/expenses/domain/entities/expense.dart';
import 'package:tripmate/features/expenses/presentation/category_icons.dart';

/// A single expense row for the list / approval queue (UI/UX §3.8). Status is
/// shown with icon + label, never color alone (Design System §2.4).
class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    required this.expense,
    required this.onTap,
    this.payerName,
    super.key,
  });

  final Expense expense;
  final String? payerName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        foregroundColor: theme.colorScheme.onSecondaryContainer,
        child: Icon(categoryIcon(expense.category), size: 20),
      ),
      title: Text(
        expense.description?.isNotEmpty ?? false
            ? expense.description!
            : expense.category.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(_subtitle()),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            Money.format(expense.amountMinor, expense.currency),
            style: theme.textTheme.titleMedium?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          _StatusChip(expense: expense),
        ],
      ),
    );
  }

  String _subtitle() {
    final parts = <String>[expense.category.label];
    if (payerName != null) parts.add('Paid by $payerName');
    return parts.join(' · ');
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;

    if (expense.isPendingSync) {
      return _Badge(
        icon: Icons.sync,
        label: 'Syncing',
        color: theme.colorScheme.onSurfaceVariant,
      );
    }
    return switch (expense.status) {
      ExpenseStatus.pending =>
        _Badge(icon: Icons.schedule, label: 'Pending', color: semantic.warning),
      ExpenseStatus.rejected => _Badge(
          icon: Icons.cancel,
          label: 'Rejected',
          color: theme.colorScheme.error,
        ),
      ExpenseStatus.approved => _Badge(
          icon: Icons.check_circle,
          label: 'Approved',
          color: semantic.success,
        ),
    };
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
