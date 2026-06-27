import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/features/reports/domain/entities/report_data.dart';
import 'package:tripmate/features/reports/presentation/widgets/report_data_table.dart';

/// Spend-by-member as grouped paid/owed bars (Design System §14.2) plus the
/// mandatory text/table equivalent (Accessibility §14.3).
class MemberBarChart extends StatelessWidget {
  const MemberBarChart({
    required this.data,
    required this.currency,
    super.key,
  });

  final ReportData data;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paidColor = theme.colorScheme.primary;
    final owedColor = theme.colorScheme.tertiary;
    final members = data.members;

    final maxMinor = members.fold<int>(
      0,
      (m, e) => [m, e.paidMinor, e.owedMinor].reduce((a, b) => a > b ? a : b),
    );
    final maxMajor = maxMinor == 0 ? 1.0 : (maxMinor / 100) * 1.2;

    final summary = members
        .map((m) => '${m.memberName} paid '
            '${Money.format(m.paidMinor, currency)}')
        .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Legend(paidColor: paidColor, owedColor: owedColor),
        const SizedBox(height: AppSpacing.md),
        Semantics(
          label: 'Spend by member. $summary.',
          child: ExcludeSemantics(
            child: SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  maxY: maxMajor,
                  alignment: BarChartAlignment.spaceAround,
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: theme.colorScheme.outlineVariant,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    leftTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= members.length) {
                            return const SizedBox.shrink();
                          }
                          final name = members[index].memberName;
                          return Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              name.length > 6 ? name.substring(0, 6) : name,
                              style: theme.textTheme.labelSmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    for (var i = 0; i < members.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: members[i].paidMinor / 100,
                            color: paidColor,
                            width: 9,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                          BarChartRodData(
                            toY: members[i].owedMinor / 100,
                            color: owedColor,
                            width: 9,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                duration: MediaQuery.of(context).disableAnimations
                    ? Duration.zero
                    : const Duration(milliseconds: 400),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ReportDataTable(
          columns: const ['Member', 'Paid', 'Owed'],
          rows: [
            for (final m in members)
              ReportTableRow(
                cells: [
                  m.memberName,
                  Money.format(m.paidMinor, currency),
                  Money.format(m.owedMinor, currency),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.paidColor, required this.owedColor});

  final Color paidColor;
  final Color owedColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LegendItem(color: paidColor, label: 'Paid'),
        const SizedBox(width: AppSpacing.lg),
        _LegendItem(color: owedColor, label: 'Owed'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
