import 'package:freezed_annotation/freezed_annotation.dart';

part 'premium_plan.freezed.dart';

/// Billing period of a plan (UI/UX §3.19).
enum PlanPeriod { monthly, yearly }

/// A purchasable Premium plan as surfaced by the store (UI/UX §3.19). The
/// [priceLabel] is the store-localized price string — never computed client-side.
@freezed
class PremiumPlan with _$PremiumPlan {
  const factory PremiumPlan({
    required String id,
    required String title,
    required String priceLabel,
    required PlanPeriod period,
    String? tagline,
  }) = _PremiumPlan;

  const PremiumPlan._();

  bool get isYearly => period == PlanPeriod.yearly;
}
