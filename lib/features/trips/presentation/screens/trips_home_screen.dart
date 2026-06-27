import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripmate/app/router/app_routes.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/widgets/app_state_views.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/trips/data/trip_providers.dart';
import 'package:tripmate/features/trips/domain/entities/trip.dart';
import 'package:tripmate/features/trips/presentation/controllers/trip_actions_controller.dart';
import 'package:tripmate/features/trips/presentation/widgets/trip_card.dart';

/// Home: list of active trips (UI/UX §3.5). Replaces the Sprint 1 placeholder.
class TripsHomeScreen extends ConsumerStatefulWidget {
  const TripsHomeScreen({super.key});

  @override
  ConsumerState<TripsHomeScreen> createState() => _TripsHomeScreenState();
}

class _TripsHomeScreenState extends ConsumerState<TripsHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Start realtime ingest + initial pull (Architecture §9). Safe offline.
    Future.microtask(
      () => ref.read(tripRepositoryProvider).refreshFromRemote(),
    );
  }

  Future<void> _confirmDelete(Trip trip) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete trip?'),
        content: Text(
          '"${trip.name}" will be removed. You can restore it within 30 days.',
        ),
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
    final message = failure?.displayMessage ?? success;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(activeTripsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips'),
        actions: [
          IconButton(
            icon: const Icon(Icons.archive_outlined),
            tooltip: 'Archived trips',
            onPressed: () => context.pushNamed(AppRoutes.archivedTripsName),
          ),
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
          message: error is Failure ? error.displayMessage : 'Failed to load.',
          onRetry: () => ref.invalidate(activeTripsProvider),
        ),
        data: (trips) {
          if (trips.isEmpty) {
            return AppEmptyView(
              icon: Icons.luggage_outlined,
              message:
                  'No trips yet.\nCreate your first trip to start tracking.',
              actionLabel: 'New Trip',
              onAction: () => context.pushNamed(AppRoutes.createTripName),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(tripRepositoryProvider).refreshFromRemote(),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.huge,
              ),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return TripCard(
                  trip: trip,
                  onTap: () => context.pushNamed(
                    AppRoutes.tripDashboardName,
                    pathParameters: {'id': trip.id},
                  ),
                  menuItems: const [
                    PopupMenuItem(value: 'archive', child: Text('Archive')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  onMenuSelected: (value) {
                    if (value == 'archive') {
                      _archive(trip);
                    } else if (value == 'delete') {
                      _confirmDelete(trip);
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
