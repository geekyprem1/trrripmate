import 'package:flutter/material.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/features/trips/domain/entities/trip.dart';

/// Trip summary card for the Home / Archived lists (UI/UX §3.5).
class TripCard extends StatelessWidget {
  const TripCard({
    required this.trip,
    required this.onTap,
    this.menuItems = const [],
    this.onMenuSelected,
    super.key,
  });

  final Trip trip;
  final VoidCallback onTap;
  final List<PopupMenuEntry<String>> menuItems;
  final ValueChanged<String>? onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = _subtitle();

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      trip.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (trip.isPendingSync)
                    Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.sm),
                      child: Icon(
                        Icons.sync,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                        semanticLabel: 'Pending sync',
                      ),
                    ),
                  if (menuItems.isNotEmpty)
                    PopupMenuButton<String>(
                      itemBuilder: (_) => menuItems,
                      onSelected: onMenuSelected,
                      icon: const Icon(Icons.more_vert),
                    ),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
              if (trip.hasBudget) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Budget ${Money.format(trip.totalBudgetMinor!, trip.currency)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String? _subtitle() {
    final parts = <String>[];
    if (trip.destination != null && trip.destination!.isNotEmpty) {
      parts.add(trip.destination!);
    }
    final dates = _dateRange();
    if (dates != null) parts.add(dates);
    return parts.isEmpty ? null : parts.join(' · ');
  }

  String? _dateRange() {
    final start = trip.startDate;
    if (start == null) return null;
    final end = trip.endDate;
    if (end == null) return _formatDate(start);
    return '${_formatDate(start)} – ${_formatDate(end)}';
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime date) => '${_months[date.month - 1]} ${date.day}';
}
