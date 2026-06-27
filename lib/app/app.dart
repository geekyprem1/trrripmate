import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripmate/app/router/app_router.dart';
import 'package:tripmate/app/theme/app_theme.dart';
import 'package:tripmate/core/sync/sync_providers.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/friends/data/friends_providers.dart';
import 'package:tripmate/features/premium/data/premium_providers.dart';
import 'package:tripmate/features/trips/data/trip_providers.dart';

/// Root application widget. Theme follows the system setting by default
/// (Design System §13.2); routing is driven by [goRouterProvider].
class TripMateApp extends ConsumerWidget {
  const TripMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(premiumRepositoryProvider);

    // Trigger sync + remote refresh whenever user becomes authenticated.
    ref.listen(authStateProvider, (previous, next) {
      final wasLoggedIn = previous?.valueOrNull != null;
      final isLoggedIn = next.valueOrNull != null;
      if (!wasLoggedIn && isLoggedIn) {
        // Drain queued writes then pull trips from server on login/cold start.
        Future.microtask(() async {
          await ref.read(syncEngineProvider).requestSync();
          await ref.read(tripRepositoryProvider).refreshFromRemote();
          await ref.read(friendsRepositoryProvider).refreshFromRemote();
        });
      }
    });

    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'TripMate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
