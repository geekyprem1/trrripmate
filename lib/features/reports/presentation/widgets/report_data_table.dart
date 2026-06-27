import 'package:flutter/material.dart';
import 'package:tripmate/app/theme/app_spacing.dart';

/// One row of a [ReportDataTable]: an optional legend [swatch] plus text cells
/// (first cell left-aligned/label, remaining cells right-aligned/values).
class ReportTableRow {
  const ReportTableRow({required this.cells, this.swatch});

  final List<String> cells;
  final Color? swatch;
}

/// The mandatory text/table equivalent that accompanies every chart
/// (Design System §14.3, Accessibility). Plain readable text — no chart
/// dependency — so screen readers and the eye get the same numbers.
class ReportDataTable extends StatelessWidget {
  const ReportDataTable({
    required this.columns,
    required this.rows,
    super.key,
  });

  final List<String> columns;
  final List<ReportTableRow> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _Row(
          cells: columns,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          hasLeadingSwatch: rows.any((r) => r.swatch != null),
        ),
        const Divider(height: AppSpacing.md),
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: _Row(
              cells: row.cells,
              style: theme.textTheme.bodyMedium,
              swatch: row.swatch,
              hasLeadingSwatch: rows.any((r) => r.swatch != null),
            ),
          ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.cells,
    required this.style,
    required this.hasLeadingSwatch,
    this.swatch,
  });

  final List<String> cells;
  final TextStyle? style;
  final Color? swatch;
  final bool hasLeadingSwatch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (hasLeadingSwatch)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: swatch ?? Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        for (var i = 0; i < cells.length; i++)
          Expanded(
            flex: i == 0 ? 2 : 1,
            child: Text(
              cells[i],
              style: style,
              textAlign: i == 0 ? TextAlign.start : TextAlign.end,
            ),
          ),
      ],
    );
  }
}
