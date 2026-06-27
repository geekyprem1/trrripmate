import 'package:tripmate/features/premium/domain/billing_service.dart';
import 'package:tripmate/features/premium/domain/entities/premium_plan.dart';
import 'package:tripmate/features/premium/domain/entities/purchase_outcome.dart';

/// Dev/sandbox [BillingService] used in v1.0. Returns a fixed plan catalogue and
/// simulates a successful purchase so the entitlement flow is exercisable
/// end-to-end without store credentials.
///
/// The production adapter (backed by `in_app_purchase` → Play Billing /
/// StoreKit) implements the same [BillingService] port and replaces this in the
/// composition root — no caller changes (Architecture §7).
class FakeBillingService implements BillingService {
  const FakeBillingService({
    this.available = true,
    this.purchaseOutcome = const PurchaseOutcome.success(
      productId: _monthlyId,
      purchaseToken: 'fake-sandbox-token',
    ),
    this.restoreOutcome = const PurchaseOutcome.nothingToRestore(),
  });

  static const _monthlyId = 'premium_monthly';
  static const _yearlyId = 'premium_yearly';

  final bool available;
  final PurchaseOutcome purchaseOutcome;
  final PurchaseOutcome restoreOutcome;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<List<PremiumPlan>> loadPlans() async => const [
        PremiumPlan(
          id: _monthlyId,
          title: 'Monthly',
          priceLabel: r'$4.99 / month',
          period: PlanPeriod.monthly,
        ),
        PremiumPlan(
          id: _yearlyId,
          title: 'Yearly',
          priceLabel: r'$39.99 / year',
          period: PlanPeriod.yearly,
          tagline: 'Save 33%',
        ),
      ];

  @override
  Future<PurchaseOutcome> purchase(String planId) async {
    if (!available) {
      return const PurchaseOutcome.failed('The store is unavailable.');
    }
    return purchaseOutcome;
  }

  @override
  Future<PurchaseOutcome> restore() async => restoreOutcome;
}
