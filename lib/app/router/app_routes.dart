/// Typed route paths and names (CLAUDE.md §11 — no raw path strings in widgets).
abstract final class AppRoutes {
  static const splashPath = '/splash';
  static const splashName = 'splash';

  static const signInPath = '/sign-in';
  static const signInName = 'sign-in';

  static const otpPath = '/otp';
  static const otpName = 'otp';

  static const profileSetupPath = '/profile-setup';
  static const profileSetupName = 'profile-setup';

  // Trips home is the authenticated landing (Sprint 2).
  static const homePath = '/trips';
  static const homeName = 'trips';

  static const createTripPath = '/trips/new';
  static const createTripName = 'create-trip';

  static const archivedTripsPath = '/trips/archived';
  static const archivedTripsName = 'archived-trips';

  static const tripDashboardPath = '/trips/:id';
  static const tripDashboardName = 'trip-dashboard';

  static const editTripPath = '/trips/:id/edit';
  static const editTripName = 'edit-trip';

  static const membersPath = '/trips/:id/members';
  static const membersName = 'members';

  static const addExpensePath = '/trips/:id/expenses/new';
  static const addExpenseName = 'add-expense';

  static const approvalsPath = '/trips/:id/approvals';
  static const approvalsName = 'approvals';

  static const expenseDetailPath = '/trips/:id/expenses/:eid';
  static const expenseDetailName = 'expense-detail';

  static const editExpensePath = '/trips/:id/expenses/:eid/edit';
  static const editExpenseName = 'edit-expense';

  // Deep-link target for invitations (accessible signed-out for preview).
  static const invitePath = '/invite/:code';
  static const inviteName = 'invite';

  // Friends screen.
  static const friendsPath = '/friends';
  static const friendsName = 'friends';

  // Trip Planner (per-trip pre-budget planning).
  static const tripPlannerPath = '/trips/:id/planner';
  static const tripPlannerName = 'trip-planner';

  // Notifications screen.
  static const notificationsPath = '/notifications';
  static const notificationsName = 'notifications';

  // Settings / Profile (UI/UX §3.18, Sprint 7).
  static const settingsPath = '/settings';
  static const settingsName = 'settings';

  // Paywall / Premium (UI/UX §3.19, Sprint 7).
  static const paywallPath = '/premium';
  static const paywallName = 'paywall';
}

/// Navigation argument for the OTP screen.
class OtpArgs {
  const OtpArgs({required this.phone});

  final String phone;
}
