import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripmate/app/router/app_routes.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/widgets/app_state_views.dart';
import 'package:tripmate/features/expenses/data/expense_providers.dart';
import 'package:tripmate/features/expenses/presentation/widgets/expenses_tab.dart';
import 'package:tripmate/features/reports/presentation/screens/reports_tab.dart';
import 'package:tripmate/features/settlement/presentation/widgets/settlement_tab.dart';
import 'package:tripmate/features/trips/data/trip_providers.dart';
import 'package:tripmate/features/trips/domain/budget_calculator.dart';
import 'package:tripmate/features/trips/domain/entities/trip.dart';
import 'package:tripmate/features/trips/presentation/controllers/trip_actions_controller.dart';
import 'package:tripmate/features/trips/presentation/widgets/budget_header.dart';

/// Trip dashboard shell — the per-trip composition point for the Dashboard,
/// Expenses, Settlement and Reports tabs (UI/UX §3.7). As the shell it wires in
/// other features' public providers/widgets (Settlement/Reports land later).
class TripDashboardScreen extends ConsumerStatefulWidget {
  const TripDashboardScreen({required this.tripId, super.key});

  final String tripId;

  @override
  ConsumerState<TripDashboardScreen> createState() =>
      _TripDashboardScreenState();
}

class _TripDashboardScreenState extends ConsumerState<TripDashboardScreen> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(tripByIdProvider(widget.tripId));

    return tripAsync.when(
      loading: () => const Scaffold(body: AppLoadingView()),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: AppErrorView(
          message: error is Failure ? error.displayMessage : 'Failed to load.',
        ),
      ),
      data: (trip) {
        if (trip == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const AppEmptyView(
                message: 'This trip is no longer available.'),
          );
        }
        return _buildScaffold(context, trip);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, Trip trip) {
    final isArchived = trip.status == TripStatus.archived;

    return Scaffold(
      appBar: AppBar(
        title: Text(trip.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_outlined),
            tooltip: 'Members',
            onPressed: () => context.pushNamed(
              AppRoutes.membersName,
              pathParameters: {'id': trip.id},
            ),
          ),
          if (!isArchived)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit trip',
              onPressed: () => context.pushNamed(
                AppRoutes.editTripName,
                pathParameters: {'id': trip.id},
              ),
            ),
          PopupMenuButton<String>(
            onSelected: (value) => _onMenu(value, trip),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'archive',
                child: Text(isArchived ? 'Unarchive' : 'Archive'),
              ),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      floatingActionButton: (!isArchived && _tabIndex <= 1)
          ? FloatingActionButton.extended(
              onPressed: () => context.pushNamed(
                AppRoutes.addExpenseName,
                pathParameters: {'id': trip.id},
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add Expense'),
            )
          : null,
      body: _buildTab(context, trip, isArchived),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (index) => setState(() => _tabIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Expenses',
          ),
          NavigationDestination(
            icon: Icon(Icons.handshake_outlined),
            label: 'Settlement',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            label: 'Reports',
          ),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, Trip trip, bool isArchived) {
    return switch (_tabIndex) {
      0 => _DashboardTab(trip: trip, isArchived: isArchived),
      1 => ExpensesTab(tripId: trip.id),
      2 => SettlementTab(
          tripId: trip.id,
          currency: trip.currency,
          isArchived: isArchived,
        ),
      _ => ReportsTab(
          tripId: trip.id,
          tripName: trip.name,
          currency: trip.currency,
        ),
    };
  }

  Future<void> _onMenu(String value, Trip trip) async {
    final controller = ref.read(tripActionsControllerProvider.notifier);
    if (value == 'archive') {
      final isArchived = trip.status == TripStatus.archived;
      final failure =
          await controller.setArchived(trip.id, archived: !isArchived);
      _showResult(failure, success: isArchived ? 'Unarchived' : 'Archived');
    } else if (value == 'delete') {
      final confirmed = await _confirmDelete(trip);
      if (confirmed) {
        final failure = await controller.delete(trip.id);
        if (failure == null && mounted) {
          context.pop();
          return;
        }
        _showResult(failure, success: 'Deleted');
      }
    }
  }

  Future<bool> _confirmDelete(Trip trip) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete trip?'),
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
    return confirmed ?? false;
  }

  void _showResult(Failure? failure, {required String success}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(failure?.displayMessage ?? success)),
      );
  }
}

class _DashboardTab extends ConsumerWidget {
  const _DashboardTab({required this.trip, required this.isArchived});

  final Trip trip;
  final bool isArchived;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Spent = sum of approved expenses (PRD REQ-BUD-01); updates reactively.
    final spentMinor =
        ref.watch(approvedSpentMinorProvider(trip.id)).valueOrNull ?? 0;
    final summary = BudgetCalculator.compute(
      trip,
      spentMinor: spentMinor,
      now: DateTime.now(),
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        if (isArchived)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              children: [
                Icon(Icons.lock_outline,
                    size: 18, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Archived — read only',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        BudgetHeader(summary: summary),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Add expenses from the Expenses tab to track spending.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
