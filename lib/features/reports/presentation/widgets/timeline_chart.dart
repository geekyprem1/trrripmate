import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/features/reports/domain/entities/report_data.dart';
import 'package:tripmate/features/reports/presentation/widgets/report_data_table.dart';

/// Spend timeline as a line chart with a daily/cumulative toggle (Design System
/// §14.2) plus the mandatory text/table equivalent (Accessibility §14.3).
class TimelineChart extends StatefulWidget {
  const TimelineChart({
    required this.data,
    required this.currency,
    super.key,
  });

  final ReportData data;
  final String currency;

  @override
  State<TimelineChart> createState() => _TimelineChartState();
}

class _TimelineChartState extends State<TimelineChart> {
  bool _cumulative = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final points = widget.data.timeline;
    int valueOf(int index) => _cumulative
        ? points[index].cumulativeMinor
        : points[index].dailyMinor;

    final maxMinor = points.isEmpty
        ? 0
        : List.generate(points.length, valueOf).reduce((a, b) => a > b ? a : b);
    final maxMajor = maxMinor == 0 ? 1.0 : (maxMinor / 100) * 1.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: true, label: Text('Cumulative')),
            ButtonSegment(value: false, label: Text('Daily')),
          ],
          selected: {_cumulative},
          onSelectionChanged: (s) => setState(() => _cumulative = s.first),
        ),
        const SizedBox(height: AppSpacing.md),
        Semantics(
          label: '${_cumulative ? 'Cumulative' : 'Daily'} spend timeline over '
              '${points.length} day(s).',
          child: ExcludeSemantics(
            child: SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxMajor,
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
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 ||
                              index >= points.length ||
                              points.length > 8 && index % 2 != 0) {
                            return const SizedBox.shrink();
                          }
                          final date = points[index].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              '${date.month}/${date.day}',
                              style: theme.textTheme.labelSmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      ),
                      spots: [
                        for (var i = 0; i < points.length; i++)
                          FlSpot(i.toDouble(), valueOf(i) / 100),
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
          columns: const ['Date', 'Daily', 'Cumulative'],
          rows: [
            for (final p in points)
              ReportTableRow(
                cells: [
                  '${p.date.year}-${_pad2(p.date.month)}-${_pad2(p.date.day)}',
                  Money.format(p.dailyMinor, widget.currency),
                  Money.format(p.cumulativeMinor, widget.currency),
                ],
              ),
          ],
        ),
      ],
    );
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');
}
