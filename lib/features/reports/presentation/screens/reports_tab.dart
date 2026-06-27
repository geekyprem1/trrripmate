import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripmate/app/router/app_routes.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/entitlement/premium_gate.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/core/widgets/app_state_views.dart';
import 'package:tripmate/features/expenses/data/expense_providers.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';
import 'package:tripmate/features/members/data/member_providers.dart';
import 'package:tripmate/features/members/domain/entities/member.dart';
import 'package:tripmate/features/reports/data/report_providers.dart';
import 'package:tripmate/features/reports/domain/entities/report_data.dart';
import 'package:tripmate/features/reports/domain/entities/report_filter.dart';
import 'package:tripmate/features/reports/presentation/controllers/report_export_controller.dart';
import 'package:tripmate/features/reports/presentation/controllers/report_filter_controller.dart';
import 'package:tripmate/features/reports/presentation/widgets/category_pie_chart.dart';
import 'package:tripmate/features/reports/presentation/widgets/member_bar_chart.dart';
import 'package:tripmate/features/reports/presentation/widgets/timeline_chart.dart';

enum _ChartKind { category, member, timeline }

/// The Reports tab inside the trip dashboard (UI/UX §3.15): filters, a chart
/// switcher with text/table equivalents, totals, and offline PDF export.
class ReportsTab extends ConsumerStatefulWidget {
  const ReportsTab({
    required this.tripId,
    required this.tripName,
    required this.currency,
    super.key,
  });

  final String tripId;
  final String tripName;
  final String currency;

  @override
  ConsumerState<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends ConsumerState<ReportsTab> {
  _ChartKind _chart = _ChartKind.category;

  @override
  Widget build(BuildContext context) {
    final expensesAsync =
        ref.watch(approvedExpensesDetailedProvider(widget.tripId));
    final filter = ref.watch(reportFilterControllerProvider(widget.tripId));

    return expensesAsync.when(
      loading: () => const AppLoadingView(),
      error: (error, _) => AppErrorView(
        message: error is Failure ? error.displayMessage : 'Failed to load.',
        onRetry: () =>
            ref.invalidate(approvedExpensesDetailedProvider(widget.tripId)),
      ),
      data: (_) {
        final data = ref.watch(reportDataProvider(widget.tripId, filter));
        return ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.huge),
          children: [
            _FilterBar(tripId: widget.tripId, filter: filter),
            if (data.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xxl),
                child: AppEmptyView(
                  icon: Icons.insights_outlined,
                  message: filter.isActive
                      ? 'No data for these filters.\nTry widening the range.'
                      : 'No approved expenses yet.\nApprove expenses to see reports.',
                ),
              )
            else ...[
              _TotalsHeader(data: data, currency: widget.currency),
              const SizedBox(height: AppSpacing.md),
              _ChartSwitcher(
                chart: _chart,
                onChanged: (kind) => setState(() => _chart = kind),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: _chartBody(data),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
                child: _ExportButton(
                  data: data,
                  tripName: widget.tripName,
                  currency: widget.currency,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _chartBody(ReportData data) {
    return switch (_chart) {
      _ChartKind.category =>
        CategoryPieChart(data: data, currency: widget.currency),
      _ChartKind.member =>
        MemberBarChart(data: data, currency: widget.currency),
      _ChartKind.timeline =>
        TimelineChart(data: data, currency: widget.currency),
    };
  }
}

class _TotalsHeader extends StatelessWidget {
  const _TotalsHeader({required this.data, required this.currency});

  final ReportData data;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Metric(
                label: 'Total spend',
                value: Money.format(data.totalMinor, currency),
                style: theme.textTheme.titleLarge,
              ),
              _Metric(
                label: 'Expenses',
                value: '${data.expenseCount}',
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, this.style});

  final String label;
  final String value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: theme.textTheme.labelMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: style),
      ],
    );
  }
}

class _ChartSwitcher extends StatelessWidget {
  const _ChartSwitcher({required this.chart, required this.onChanged});

  final _ChartKind chart;
  final ValueChanged<_ChartKind> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: SegmentedButton<_ChartKind>(
        segments: const [
          ButtonSegment(
            value: _ChartKind.category,
            icon: Icon(Icons.pie_chart_outline),
            label: Text('Category'),
          ),
          ButtonSegment(
            value: _ChartKind.member,
            icon: Icon(Icons.bar_chart),
            label: Text('Member'),
          ),
          ButtonSegment(
            value: _ChartKind.timeline,
            icon: Icon(Icons.show_chart),
            label: Text('Timeline'),
          ),
        ],
        selected: {chart},
        showSelectedIcon: false,
        onSelectionChanged: (s) => onChanged(s.first),
      ),
    );
  }
}

class _FilterBar extends ConsumerWidget {
  const _FilterBar({required this.tripId, required this.filter});

  final String tripId;
  final ReportFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.read(reportFilterControllerProvider(tripId).notifier);
    final members = ref.watch(tripMembersProvider(tripId)).valueOrNull ?? [];
    final names = {for (final m in members) m.id: m.displayName ?? 'Member'};

    final dateLabel = filter.start != null || filter.end != null
        ? 'Dates: ${_short(filter.start)}–${_short(filter.end)}'
        : 'Dates';
    final memberLabel = filter.memberId != null
        ? names[filter.memberId] ?? 'Member'
        : 'Member';
    final categoryLabel =
        filter.category != null ? filter.category!.label : 'Category';

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: [
          FilterChip(
            label: Text(dateLabel),
            selected: filter.start != null || filter.end != null,
            onSelected: (_) => _pickDates(context, controller),
          ),
          const SizedBox(width: AppSpacing.sm),
          FilterChip(
            label: Text(memberLabel),
            selected: filter.memberId != null,
            onSelected: (_) => _pickMember(context, controller, members),
          ),
          const SizedBox(width: AppSpacing.sm),
          FilterChip(
            label: Text(categoryLabel),
            selected: filter.category != null,
            onSelected: (_) => _pickCategory(context, controller),
          ),
          if (filter.isActive) ...[
            const SizedBox(width: AppSpacing.sm),
            ActionChip(
              avatar: const Icon(Icons.clear, size: 18),
              label: const Text('Clear'),
              onPressed: controller.clear,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickDates(
    BuildContext context,
    ReportFilterController controller,
  ) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1, 12, 31),
    );
    if (range != null) controller.setDateRange(range.start, range.end);
  }

  Future<void> _pickMember(
    BuildContext context,
    ReportFilterController controller,
    List<Member> members,
  ) async {
    final selected = await showModalBottomSheet<String?>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.group_off_outlined),
              title: const Text('All members'),
              onTap: () => Navigator.pop(sheetContext),
            ),
            for (final m in members)
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(m.displayName ?? 'Member'),
                onTap: () => Navigator.pop(sheetContext, m.id),
              ),
          ],
        ),
      ),
    );
    controller.setMember(selected);
  }

  Future<void> _pickCategory(
    BuildContext context,
    ReportFilterController controller,
  ) async {
    final selected = await showModalBottomSheet<Object?>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.clear_all),
                title: const Text('All categories'),
                onTap: () => Navigator.pop(sheetContext, 'all'),
              ),
              for (final c in ExpenseCategory.values)
                ListTile(
                  title: Text(c.label),
                  onTap: () => Navigator.pop(sheetContext, c),
                ),
            ],
          ),
        ),
      ),
    );
    if (selected == 'all') {
      controller.setCategory(null);
    } else if (selected is ExpenseCategory) {
      controller.setCategory(selected);
    }
  }

  String _short(DateTime? date) {
    if (date == null) return '…';
    return '${date.month}/${date.day}';
  }
}

class _ExportButton extends ConsumerWidget {
  const _ExportButton({
    required this.data,
    required this.tripName,
    required this.currency,
  });

  final ReportData data;
  final String tripName;
  final String currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExporting =
        ref.watch(reportExportControllerProvider).isLoading;
    // PDF export is a Premium feature (Sprint 7, PRD §12).
    final isPremium = ref.watch(premiumGateProvider);

    return FilledButton.icon(
      onPressed: isExporting
          ? null
          : () => _onTap(context, ref, isPremium: isPremium),
      icon: isExporting
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(isPremium
              ? Icons.picture_as_pdf_outlined
              : Icons.lock_outline_rounded),
      label: Text(isExporting
          ? 'Preparing PDF…'
          : isPremium
              ? 'Export PDF'
              : 'Export PDF — Premium'),
    );
  }

  void _onTap(BuildContext context, WidgetRef ref,
      {required bool isPremium}) {
    if (!isPremium) {
      // Free-tier: redirect to paywall instead of exporting.
      context.pushNamed(AppRoutes.paywallName);
      return;
    }
    _export(context, ref);
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final failure = await ref
        .read(reportExportControllerProvider.notifier)
        .export(data: data, tripName: tripName, currency: currency);
    if (failure != null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failure.displayMessage)));
    }
  }
}
