import 'package:flutter/material.dart';
import 'package:tripmate/app/theme/app_colors.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/features/forecast/presentation/widgets/forecast_sheet.dart';
import 'package:tripmate/features/trips/domain/entities/budget_summary.dart';

/// Budget summary card: Total / Spent / Remaining / Daily with an over-budget
/// flag (UI/UX §3.7, PRD REQ-BUD-01). Over-budget uses icon + text, never color
/// alone (Design System §2.4).
class BudgetHeader extends StatelessWidget {
  const BudgetHeader({
    required this.summary,
    required this.tripId,
    super.key,
  });

  final BudgetSummary summary;
  final String tripId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;
    final currency = summary.currency;

    final progress = _progress();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Budget', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            if (summary.hasBudget) ...[
              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
                color: summary.overBudget ? theme.colorScheme.error : null,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Row(
              children: [
                _Metric(
                  label: 'Spent',
                  value: Money.format(summary.spentMinor, currency),
                ),
                if (summary.hasBudget)
                  _Metric(
                    label: 'Total',
                    value: Money.format(summary.totalMinor!, currency),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                if (summary.remainingMinor != null)
                  _Metric(
                    label: 'Remaining',
                    value: Money.format(summary.remainingMinor!, currency),
                    valueColor: summary.overBudget
                        ? semantic.moneyNegative
                        : semantic.moneyPositive,
                    trailing: _ForecastButton(
                      tripId: tripId,
                      currency: currency,
                      remainingMinor: summary.remainingMinor,
                    ),
                  ),
                _Metric(
                  label: 'Daily spend',
                  value: Money.format(summary.dailySpendMinor, currency),
                ),
              ],
            ),
            if (summary.overBudget) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(Icons.warning_amber,
                      size: 18, color: theme.colorScheme.error),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Over budget',
                    style: theme.textTheme.labelLarge
                        ?.copyWith(color: theme.colorScheme.error),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  double? _progress() {
    final total = summary.totalMinor;
    if (total == null || total == 0) return null;
    return (summary.spentMinor / total).clamp(0.0, 1.0);
  }
}

// ---------------------------------------------------------------------------
// Forecast launch button shown next to the Remaining metric label
// ---------------------------------------------------------------------------

class _ForecastButton extends StatelessWidget {
  const _ForecastButton({
    required this.tripId,
    required this.currency,
    required this.remainingMinor,
  });

  final String tripId;
  final String currency;
  final int? remainingMinor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => ForecastSheet(
          tripId: tripId,
          currency: currency,
          remainingMinor: remainingMinor,
        ),
      ),
      child: Tooltip(
        message: 'Forecast calculator',
        child: Icon(
          Icons.calculate_outlined,
          size: 18,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Metric tile
// ---------------------------------------------------------------------------

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.valueColor,
    this.trailing,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.xs),
                trailing!,
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: valueColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
