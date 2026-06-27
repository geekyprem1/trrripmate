import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripmate/app/router/app_router.dart';
import 'package:tripmate/app/theme/app_theme.dart';
import 'package:tripmate/features/premium/data/premium_providers.dart';

/// Root application widget. Theme follows the system setting by default
/// (Design System §13.2); routing is driven by [goRouterProvider].
class TripMateApp extends ConsumerWidget {
  const TripMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Eagerly initialise so hydrate() seeds the PremiumGate from the local
    // cache on cold start — ensuring quota gating is offline-correct (Sprint 7).
    ref.watch(premiumRepositoryProvider);
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'TripMate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      // themeMode defaults to ThemeMode.system (Design System §13.2).
      routerConfig: router,
    );
  }
}
