import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/analytics/analytics_service.dart';
import 'package:tripmate/core/providers/core_providers.dart';
import 'package:tripmate/features/premium/data/premium_providers.dart';
import 'package:tripmate/features/premium/domain/entities/purchase_outcome.dart';

part 'paywall_controller.g.dart';

/// Drives the Paywall screen's purchase and restore flows (UI/UX §3.19).
/// Uses [AsyncNotifier] so the UI can handle all three states.
@riverpod
class PaywallController extends _$PaywallController {
  @override
  Future<void> build() async {
    // Log paywall view on first build (PRD §14, Sprint 7).
    ref
        .read(analyticsServiceProvider)
        .logEvent(AnalyticsEvents.premiumViewed);
  }

  /// Launches the purchase flow for [planId]. Returns the outcome so callers
  /// can show result messages without coupling to this notifier's state.
  Future<PurchaseOutcome> purchase(String planId) async {
    state = const AsyncValue.loading();
    final outcome =
        await ref.read(premiumRepositoryProvider).purchase(planId);
    if (outcome is PurchaseSuccess) {
      ref
          .read(analyticsServiceProvider)
          .logEvent(AnalyticsEvents.subscriptionPurchased,
              properties: {'plan_id': planId});
    }
    state = const AsyncValue.data(null);
    return outcome;
  }

  /// Restores a prior purchase. Returns the outcome for caller-side feedback.
  Future<PurchaseOutcome> restore() async {
    state = const AsyncValue.loading();
    final outcome = await ref.read(premiumRepositoryProvider).restore();
    state = const AsyncValue.data(null);
    return outcome;
  }
}
