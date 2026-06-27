import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/app/theme/app_chart_palette.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/features/reports/domain/entities/report_data.dart';
import 'package:tripmate/features/reports/presentation/widgets/report_data_table.dart';

/// Category breakdown as a donut (Design System §14.2) plus its mandatory
/// text/table equivalent (Accessibility, §14.3). The chart itself is excluded
/// from semantics; the summary + table carry the non-visual content.
class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({
    required this.data,
    required this.currency,
    super.key,
  });

  final ReportData data;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final summary = data.categories
        .map((c) => '${c.category.label} '
            '${(c.fraction * 100).toStringAsFixed(0)}%')
        .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: 'Category breakdown. $summary.',
          child: ExcludeSemantics(
            child: SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 56,
                      sections: [
                        for (var i = 0; i < data.categories.length; i++)
                          PieChartSectionData(
                            value: data.categories[i].amountMinor.toDouble(),
                            color: AppChartPalette.at(i),
                            radius: 46,
                            title:
                                '${(data.categories[i].fraction * 100).toStringAsFixed(0)}%',
                            titleStyle: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 400),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Total', style: theme.textTheme.labelSmall),
                      Text(
                        Money.format(data.totalMinor, currency),
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ReportDataTable(
          columns: const ['Category', 'Amount', 'Share'],
          rows: [
            for (var i = 0; i < data.categories.length; i++)
              ReportTableRow(
                swatch: AppChartPalette.at(i),
                cells: [
                  data.categories[i].category.label,
                  Money.format(data.categories[i].amountMinor, currency),
                  '${(data.categories[i].fraction * 100).toStringAsFixed(1)}%',
                ],
              ),
          ],
        ),
      ],
    );
  }
}
