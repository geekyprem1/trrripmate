import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/app/router/app_routes.dart';
import 'package:tripmate/features/auth/data/auth_providers.dart';
import 'package:tripmate/features/auth/presentation/screens/otp_screen.dart';
import 'package:tripmate/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:tripmate/features/auth/presentation/screens/settings_screen.dart';
import 'package:tripmate/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:tripmate/features/auth/presentation/screens/splash_screen.dart';
import 'package:tripmate/features/expenses/presentation/screens/approval_queue_screen.dart';
import 'package:tripmate/features/expenses/presentation/screens/expense_detail_screen.dart';
import 'package:tripmate/features/expenses/presentation/screens/expense_screen_loaders.dart';
import 'package:tripmate/features/members/presentation/controllers/pending_invite.dart';
import 'package:tripmate/features/members/presentation/screens/join_trip_screen.dart';
import 'package:tripmate/features/members/presentation/screens/members_screen.dart';
import 'package:tripmate/features/friends/presentation/screens/friends_screen.dart';
import 'package:tripmate/features/members/presentation/screens/notifications_screen.dart';
import 'package:tripmate/features/trips/presentation/screens/trip_planner_screen.dart';
import 'package:tripmate/features/premium/presentation/screens/paywall_screen.dart';
import 'package:tripmate/features/trips/presentation/screens/archived_trips_screen.dart';
import 'package:tripmate/features/trips/presentation/screens/create_edit_trip_screen.dart';
import 'package:tripmate/features/trips/presentation/screens/trip_dashboard_screen.dart';
import 'package:tripmate/features/trips/presentation/screens/trips_home_screen.dart';

part 'app_router.g.dart';

/// Application router with auth + onboarding guards (Architecture §5/§8).
///
/// Redirect resolves three gates: session unknown → Splash; signed-out →
/// Sign In/OTP; signed-in without a profile → Profile Setup; otherwise Home.
@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final refresh = ValueNotifier<int>(0);
  ref
    ..onDispose(refresh.dispose)
    ..listen(authStateProvider, (_, __) => refresh.value++)
    ..listen(profileStatusProvider, (_, __) => refresh.value++)
    ..listen(pendingInviteProvider, (_, __) => refresh.value++);

  return GoRouter(
    initialLocation: AppRoutes.splashPath,
    refreshListenable: refresh,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splashName,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.signInPath,
        name: AppRoutes.signInName,
        builder: (_, __) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpPath,
        name: AppRoutes.otpName,
        builder: (_, state) {
          final args = state.extra as OtpArgs?;
          // Defensive: without a phone there is nothing to verify.
          if (args == null) return const SignInScreen();
          return OtpScreen(phone: args.phone);
        },
      ),
      GoRoute(
        path: AppRoutes.profileSetupPath,
        name: AppRoutes.profileSetupName,
        builder: (_, __) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.homeName,
        builder: (_, __) => const TripsHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.createTripPath,
        name: AppRoutes.createTripName,
        builder: (_, __) => const CreateEditTripScreen(),
      ),
      GoRoute(
        path: AppRoutes.archivedTripsPath,
        name: AppRoutes.archivedTripsName,
        builder: (_, __) => const ArchivedTripsScreen(),
      ),
      GoRoute(
        path: AppRoutes.tripDashboardPath,
        name: AppRoutes.tripDashboardName,
        builder: (_, state) =>
            TripDashboardScreen(tripId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.editTripPath,
        name: AppRoutes.editTripName,
        builder: (_, state) =>
            EditTripLoader(tripId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.membersPath,
        name: AppRoutes.membersName,
        builder: (_, state) =>
            MembersScreen(tripId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.invitePath,
        name: AppRoutes.inviteName,
        builder: (_, state) =>
            JoinTripScreen(code: state.pathParameters['code']!),
      ),
      GoRoute(
        path: AppRoutes.addExpensePath,
        name: AppRoutes.addExpenseName,
        builder: (_, state) =>
            AddExpenseLoader(tripId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.approvalsPath,
        name: AppRoutes.approvalsName,
        builder: (_, state) =>
            ApprovalQueueScreen(tripId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.editExpensePath,
        name: AppRoutes.editExpenseName,
        builder: (_, state) =>
            EditExpenseLoader(expenseId: state.pathParameters['eid']!),
      ),
      GoRoute(
        path: AppRoutes.expenseDetailPath,
        name: AppRoutes.expenseDetailName,
        builder: (_, state) =>
            ExpenseDetailScreen(expenseId: state.pathParameters['eid']!),
      ),
      GoRoute(
        path: AppRoutes.friendsPath,
        name: AppRoutes.friendsName,
        builder: (_, __) => const FriendsScreen(),
      ),
      GoRoute(
        path: AppRoutes.tripPlannerPath,
        name: AppRoutes.tripPlannerName,
        builder: (_, state) =>
            TripPlannerScreen(tripId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.notificationsPath,
        name: AppRoutes.notificationsName,
        builder: (_, __) => const NotificationsScreen(),
      ),
      // Sprint 7 — Settings and Paywall.
      GoRoute(
        path: AppRoutes.settingsPath,
        name: AppRoutes.settingsName,
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.paywallPath,
        name: AppRoutes.paywallName,
        builder: (_, __) => const PaywallScreen(),
      ),
    ],
  );
}

String? _redirect(Ref ref, GoRouterState state) {
  final authAsync = ref.read(authStateProvider);
  final location = state.matchedLocation;

  // Session state not yet known — hold on Splash.
  if (authAsync.isLoading && !authAsync.hasValue) {
    return location == AppRoutes.splashPath ? null : AppRoutes.splashPath;
  }

  final isLoggedIn = authAsync.valueOrNull != null;
  final onAuthRoute =
      location == AppRoutes.signInPath || location == AppRoutes.otpPath;
  // Invite previews are viewable signed-out so the deep link survives sign-in.
  final onInviteRoute = location.startsWith('/invite/');

  if (!isLoggedIn) {
    return (onAuthRoute || onInviteRoute) ? null : AppRoutes.signInPath;
  }

  // Logged in: resolve onboarding.
  final profileAsync = ref.read(profileStatusProvider);
  if (profileAsync.isLoading && !profileAsync.hasValue) {
    return location == AppRoutes.splashPath ? null : AppRoutes.splashPath;
  }

  final hasProfile = profileAsync.valueOrNull ?? false;
  if (!hasProfile) {
    return location == AppRoutes.profileSetupPath
        ? null
        : AppRoutes.profileSetupPath;
  }

  // Fully onboarded: resume a pending invite captured before sign-in.
  final pendingInvite = ref.read(pendingInviteProvider);
  if (pendingInvite != null && !onInviteRoute) {
    return '/invite/$pendingInvite';
  }

  // Keep out of the auth/splash/onboarding flow.
  if (onAuthRoute ||
      location == AppRoutes.splashPath ||
      location == AppRoutes.profileSetupPath) {
    return AppRoutes.homePath;
  }
  return null;
}
