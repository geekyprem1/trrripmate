import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripmate/app/router/app_routes.dart';
import 'package:tripmate/app/theme/app_spacing.dart';
import 'package:tripmate/core/error/failure.dart';
import 'package:tripmate/core/widgets/app_state_views.dart';
import 'package:tripmate/features/trips/data/trip_providers.dart';
import 'package:tripmate/features/trips/domain/entities/trip.dart';
import 'package:tripmate/features/trips/presentation/controllers/trip_actions_controller.dart';
import 'package:tripmate/features/trips/presentation/widgets/trip_card.dart';

/// Archived trips list with unarchive (UI/UX §3.17).
class ArchivedTripsScreen extends ConsumerWidget {
  const ArchivedTripsScreen({super.key});

  Future<void> _unarchive(
    BuildContext context,
    WidgetRef ref,
    Trip trip,
  ) async {
    final failure = await ref
        .read(tripActionsControllerProvider.notifier)
        .setArchived(trip.id, archived: false);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(failure?.displayMessage ?? 'Trip restored')),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(archivedTripsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Archived trips')),
      body: tripsAsync.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(
          message: error is Failure ? error.displayMessage : 'Failed to load.',
          onRetry: () => ref.invalidate(archivedTripsProvider),
        ),
        data: (trips) {
          if (trips.isEmpty) {
            return const AppEmptyView(
              icon: Icons.archive_outlined,
              message: 'No archived trips.',
            );
          }
          return ListView.builder(
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
                  PopupMenuItem(value: 'unarchive', child: Text('Unarchive')),
                ],
                onMenuSelected: (value) {
                  if (value == 'unarchive') _unarchive(context, ref, trip);
                },
              );
            },
          );
        },
      ),
    );
  }
}
