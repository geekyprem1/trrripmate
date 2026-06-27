import 'package:tripmate/features/trips/domain/entities/budget_summary.dart';
import 'package:tripmate/features/trips/domain/entities/trip.dart';

/// Pure budget computation (PRD REQ-BUD-01). Spent = sum of approved expenses
/// (0 until Sprint 4 wires expenses in); remaining = total − spent; daily =
/// spent ÷ active trip days. Lowering a budget below spent flags over-budget
/// but never hides the remaining figure.
abstract final class BudgetCalculator {
  static BudgetSummary compute(
    Trip trip, {
    required int spentMinor,
    required DateTime now,
  }) {
    final total = trip.totalBudgetMinor;
    final remaining = total == null ? null : total - spentMinor;
    final days = _activeDays(trip, now);
    final dailySpend = days > 0 ? spentMinor ~/ days : spentMinor;
    final overBudget = total != null && spentMinor > total;

    return BudgetSummary(
      currency: trip.currency,
      spentMinor: spentMinor,
      dailySpendMinor: dailySpend,
      overBudget: overBudget,
      totalMinor: total,
      remainingMinor: remaining,
    );
  }

  /// Elapsed days of the trip so far, minimum 1. Uses the start date through
  /// the earlier of now and the end date.
  static int _activeDays(Trip trip, DateTime now) {
    final start = trip.startDate;
    if (start == null) return 1;
    final end = trip.endDate;
    var until = now;
    if (end != null && end.isBefore(now)) until = end;
    if (until.isBefore(start)) return 1;
    return until.difference(start).inDays + 1;
  }
}
