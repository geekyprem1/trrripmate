import 'package:tripmate/features/premium/domain/entities/entitlement.dart';
import 'package:tripmate/features/premium/domain/entities/premium_plan.dart';
import 'package:tripmate/features/premium/domain/entities/purchase_outcome.dart';

/// Domain boundary for Premium (PRD §12, API §2). Orchestrates the store
/// ([BillingService]) and server-side entitlement; persists the tier locally for
/// offline gating. No exceptions cross this boundary.
abstract interface class PremiumRepository {
  /// Reactive entitlement, seeded from cache and updated on refresh/purchase.
  Stream<Entitlement> watchEntitlement();

  /// The current cached entitlement (synchronous; for gating decisions).
  Entitlement get current;

  /// Store-localized plans for the paywall.
  Future<List<PremiumPlan>> plans();

  /// Runs the purchase flow for [planId]; on success applies server entitlement
  /// and updates the local cache + gate.
  Future<PurchaseOutcome> purchase(String planId);

  /// Restores a prior purchase and re-applies entitlement.
  Future<PurchaseOutcome> restore();

  /// Whether the platform store is reachable (for offline purchase guard).
  Future<bool> isStoreAvailable();

  /// Re-reads entitlement from the server (e.g. on launch / sign-in).
  Future<void> refresh();
}
