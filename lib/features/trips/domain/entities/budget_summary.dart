import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_summary.freezed.dart';

/// Client-derived budget figures for a trip (PRD REQ-BUD-01, Architecture §1).
///
/// Never persisted — recomputed from the trip and its expenses so it can't
/// drift. All amounts are integer minor units.
@freezed
class BudgetSummary with _$BudgetSummary {
  const factory BudgetSummary({
    required String currency,
    required int spentMinor,
    required int dailySpendMinor,
    required bool overBudget,
    int? totalMinor,
    int? remainingMinor,
  }) = _BudgetSummary;

  const BudgetSummary._();

  bool get hasBudget => totalMinor != null;
}
