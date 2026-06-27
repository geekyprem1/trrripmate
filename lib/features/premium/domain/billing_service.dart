import 'package:tripmate/features/premium/domain/entities/premium_plan.dart';
import 'package:tripmate/features/premium/domain/entities/purchase_outcome.dart';

/// Port over the platform store (Play Billing / StoreKit) — UI/UX §3.19,
/// Architecture §7. The domain depends only on this interface; concrete
/// adapters (a real `in_app_purchase` client, or the dev fake) live in `data/`.
abstract interface class BillingService {
  /// Whether the store is reachable/usable on this device right now.
  Future<bool> isAvailable();

  /// Store-localized purchasable plans.
  Future<List<PremiumPlan>> loadPlans();

  /// Launches the store purchase flow for [planId]; resolves to its outcome.
  Future<PurchaseOutcome> purchase(String planId);

  /// Restores a previously-purchased entitlement, if any.
  Future<PurchaseOutcome> restore();
}
