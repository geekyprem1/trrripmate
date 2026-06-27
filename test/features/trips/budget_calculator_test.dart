import 'package:flutter_test/flutter_test.dart';
import 'package:tripmate/features/trips/domain/budget_calculator.dart';
import 'package:tripmate/features/trips/domain/entities/trip.dart';

void main() {
  Trip trip({int? budget, DateTime? start, DateTime? end}) {
    return Trip(
      id: 't1',
      ownerId: 'u1',
      name: 'Goa',
      currency: 'INR',
      status: TripStatus.active,
      createdAt: DateTime(2026, 7),
      updatedAt: DateTime(2026, 7),
      totalBudgetMinor: budget,
      startDate: start,
      endDate: end,
    );
  }

  test('remaining = total - spent', () {
    final summary = BudgetCalculator.compute(
      trip(budget: 5000000),
      spentMinor: 1200000,
      now: DateTime(2026, 7, 3),
    );
    expect(summary.totalMinor, 5000000);
    expect(summary.remainingMinor, 3800000);
    expect(summary.overBudget, isFalse);
  });

  test('flags over budget when spent exceeds total', () {
    final summary = BudgetCalculator.compute(
      trip(budget: 1000000),
      spentMinor: 1500000,
      now: DateTime(2026, 7, 3),
    );
    expect(summary.overBudget, isTrue);
    expect(summary.remainingMinor, -500000); // never hidden
  });

  test('daily spend divides by active days', () {
    final summary = BudgetCalculator.compute(
      trip(start: DateTime(2026, 7), end: DateTime(2026, 7, 4)),
      spentMinor: 400000,
      now: DateTime(2026, 7, 4),
    );
    // 4 active days (Jul 1..4 inclusive) → 100000 per day.
    expect(summary.dailySpendMinor, 100000);
  });

  test('no budget yields null total and remaining', () {
    final summary = BudgetCalculator.compute(
      trip(),
      spentMinor: 0,
      now: DateTime(2026, 7),
    );
    expect(summary.hasBudget, isFalse);
    expect(summary.totalMinor, isNull);
    expect(summary.remainingMinor, isNull);
    expect(summary.overBudget, isFalse);
  });
}
