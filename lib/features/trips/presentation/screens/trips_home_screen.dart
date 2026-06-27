import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripmate/app/router/app_routes.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/utils/money.dart';
import 'package:tripmate/core/widgets/app_state_views.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/members/data/member_providers.dart';
import 'package:tripmate/features/trips/data/trip_providers.dart';
import 'package:tripmate/features/trips/domain/entities/trip.dart';
import 'package:tripmate/features/trips/presentation/controllers/trip_actions_controller.dart';
import 'package:tripmate/features/trips/presentation/widgets/trip_card.dart';

class TripsHomeScreen extends ConsumerStatefulWidget {
  const TripsHomeScreen({super.key});

  @override
  ConsumerState<TripsHomeScreen> createState() => _TripsHomeScreenState();
}

class _TripsHomeScreenState extends ConsumerState<TripsHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(tripRepositoryProvider).refreshFromRemote(),
    );
  }

  Future<void> _confirmDelete(Trip trip) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete trip?'),
        content: Text(
          '"${trip.name}" will be removed. You can restore it within 30 days.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed ?? false) {
      final failure = await ref
          .read(tripActionsControllerProvider.notifier)
          .delete(trip.id);
      _showResult(failure, success: 'Trip deleted');
    }
  }

  Future<void> _archive(Trip trip) async {
    final failure = await ref
        .read(tripActionsControllerProvider.notifier)
        .setArchived(trip.id, archived: true);
    _showResult(failure, success: 'Trip archived');
  }

  void _showResult(Failure? failure, {required String success}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text(failure?.displayMessage ?? success)));
  }

  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(activeTripsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TripMate'),
        actions: [
          const _NotificationBell(),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.pushNamed(AppRoutes.settingsName),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(AppRoutes.createTripName),
        icon: const Icon(Icons.add),
        label: const Text('New Trip'),
      ),
      body: tripsAsync.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(
          message:
              error is Failure ? error.displayMessage : 'Failed to load.',
          onRetry: () => ref.invalidate(activeTripsProvider),
        ),
        data: (trips) => RefreshIndicator(
          onRefresh: () =>
              ref.read(tripRepositoryProvider).refreshFromRemote(),
          child: CustomScrollView(
            slivers: [
              // Quick-action grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                  child: _QuickActionGrid(),
                ),
              ),

              // Active trip — pinned card
              if (trips.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                    child: _ActiveTripCard(trip: trips.first),
                  ),
                ),

              // All active trips section header
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xs),
                sliver: SliverToBoxAdapter(
                  child: Builder(builder: (ctx) {
                    final theme = Theme.of(ctx);
                    return Row(
                      children: [
                        Text('All Trips',
                            style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant)),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => ctx.pushNamed(
                              AppRoutes.archivedTripsName),
                          icon: const Icon(Icons.history, size: 16),
                          label: const Text('History'),
                          style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact),
                        ),
                      ],
                    );
                  }),
                ),
              ),

              // Trips list
              trips.isEmpty
                  ? SliverFillRemaining(
                      child: AppEmptyView(
                        icon: Icons.luggage_outlined,
                        message:
                            'No trips yet.\nCreate your first trip to start tracking.',
                        actionLabel: 'New Trip',
                        onAction: () =>
                            context.pushNamed(AppRoutes.createTripName),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg, 0, AppSpacing.lg, 100),
                      sliver: SliverList.builder(
                        itemCount: trips.length,
                        itemBuilder: (ctx, index) {
                          final trip = trips[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm),
                            child: TripCard(
                              trip: trip,
                              onTap: () => ctx.pushNamed(
                                AppRoutes.tripDashboardName,
                                pathParameters: {'id': trip.id},
                              ),
                              menuItems: const [
                                PopupMenuItem(
                                    value: 'archive',
                                    child: Text('Archive')),
                                PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete')),
                              ],
                              onMenuSelected: (value) {
                                if (value == 'archive') _archive(trip);
                                if (value == 'delete') _confirmDelete(trip);
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quick-action grid: Friends | Planner | Memory | History
// ---------------------------------------------------------------------------

class _QuickActionGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.sm,
      children: [
        _QuickAction(
          icon: Icons.group_rounded,
          label: 'Friends',
          color: Colors.blue,
          onTap: () => context.pushNamed(AppRoutes.friendsName),
        ),
        _QuickAction(
          icon: Icons.event_note_rounded,
          label: 'Planner',
          color: Colors.orange,
          onTap: () {
            // navigate to most recent active trip's planner, or prompt
            _showPlannerPicker(context);
          },
        ),
        _QuickAction(
          icon: Icons.photo_album_rounded,
          label: 'Memory',
          color: Colors.purple,
          comingSoon: true,
          onTap: () {},
        ),
        _QuickAction(
          icon: Icons.history_rounded,
          label: 'History',
          color: Colors.teal,
          onTap: () => context.pushNamed(AppRoutes.archivedTripsName),
        ),
      ],
    );
  }

  void _showPlannerPicker(BuildContext context) {
    // Will be handled via _PlannerPickerSheet below
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const _PlannerPickerSheet(),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.comingSoon = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool comingSoon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: comingSoon
          ? () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon!')),
              )
          : onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.25)),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              if (comingSoon)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Soon',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onTertiary,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Planner picker — choose which trip's planner to open
// ---------------------------------------------------------------------------

class _PlannerPickerSheet extends ConsumerWidget {
  const _PlannerPickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tripsAsync = ref.watch(activeTripsProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Choose a trip to plan',
                style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            tripsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Text('Could not load trips.'),
              data: (trips) {
                if (trips.isEmpty) {
                  return const Text(
                      'No active trips. Create a trip first.');
                }
                return Column(
                  children: trips
                      .map((trip) => ListTile(
                            leading: const Icon(Icons.luggage_outlined),
                            title: Text(trip.name),
                            subtitle: trip.destination != null
                                ? Text(trip.destination!)
                                : null,
                            onTap: () {
                              Navigator.pop(context);
                              context.pushNamed(
                                AppRoutes.tripPlannerName,
                                pathParameters: {'id': trip.id},
                              );
                            },
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Active trip pinned card
// ---------------------------------------------------------------------------

class _ActiveTripCard extends StatelessWidget {
  const _ActiveTripCard({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.pushNamed(
          AppRoutes.tripDashboardName,
          pathParameters: {'id': trip.id},
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: Colors.green.withOpacity(0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Active',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(trip.name,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    if (trip.destination != null)
                      Text(trip.destination!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant)),
                    if (trip.totalBudgetMinor != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Budget: ${Money.format(trip.totalBudgetMinor!, trip.currency)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary),
                      ),
                    ],
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.event_note_outlined),
                    tooltip: 'Trip Planner',
                    onPressed: () => context.pushNamed(
                      AppRoutes.tripPlannerName,
                      pathParameters: {'id': trip.id},
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notification bell with unread badge
// ---------------------------------------------------------------------------

class _NotificationBell extends ConsumerWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count =
        ref.watch(unreadNotificationsProvider).valueOrNull?.length ?? 0;
    return IconButton(
      tooltip: 'Notifications',
      onPressed: () => context.pushNamed(AppRoutes.notificationsName),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text(count > 9 ? '9+' : '$count'),
        child: const Icon(Icons.notifications_outlined),
      ),
    );
  }
}
