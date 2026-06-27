import 'package:flutter_test/flutter_test.dart';
import 'package:tripmate/features/expenses/domain/entities/expense.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';
import 'package:tripmate/features/members/domain/entities/member.dart';
import 'package:tripmate/features/reports/domain/entities/report_filter.dart';
import 'package:tripmate/features/reports/domain/report_aggregator.dart';

Expense _expense({
  required String id,
  required String paidBy,
  required int amountMinor,
  required ExpenseCategory category,
  required DateTime date,
  required Map<String, int> shares,
}) {
  return Expense(
    id: id,
    tripId: 't1',
    paidByMemberId: paidBy,
    amountMinor: amountMinor,
    currency: 'INR',
    category: category,
    date: date,
    status: ExpenseStatus.approved,
    createdBy: 'u1',
    splits: [
      for (final e in shares.entries)
        ExpenseSplit(memberId: e.key, shareMinor: e.value),
    ],
  );
}

Member _member(String id, String name) => Member(
      id: id,
      tripId: 't1',
      userId: 'u-$id',
      role: MemberRole.member,
      joinedAt: DateTime(2026),
      displayName: name,
    );

void main() {
  final members = [_member('m1', 'Amit'), _member('m2', 'Prem')];

  final foodDay1 = _expense(
    id: 'e1',
    paidBy: 'm1',
    amountMinor: 100000,
    category: ExpenseCategory.food,
    date: DateTime(2026, 7),
    shares: {'m1': 50000, 'm2': 50000},
  );
  final fuelDay2 = _expense(
    id: 'e2',
    paidBy: 'm2',
    amountMinor: 60000,
    category: ExpenseCategory.fuel,
    date: DateTime(2026, 7, 2),
    shares: {'m1': 30000, 'm2': 30000},
  );
  final foodDay2 = _expense(
    id: 'e3',
    paidBy: 'm1',
    amountMinor: 40000,
    category: ExpenseCategory.food,
    date: DateTime(2026, 7, 2),
    shares: {'m1': 20000, 'm2': 20000},
  );

  group('aggregate totals + categories', () {
    test('sums totals and computes category fractions', () {
      final data = ReportAggregator.aggregate(
        approvedExpenses: [foodDay1, fuelDay2, foodDay2],
        members: members,
      );

      expect(data.totalMinor, 200000);
      expect(data.expenseCount, 3);
      // Food = 100000 + 40000 = 140000 (70%); Fuel = 60000 (30%).
      expect(data.categories.first.category, ExpenseCategory.food);
      expect(data.categories.first.amountMinor, 140000);
      expect(data.categories.first.fraction, closeTo(0.7, 1e-9));
      expect(data.categories.last.category, ExpenseCategory.fuel);
      expect(data.categories.last.fraction, closeTo(0.3, 1e-9));
    });

    test('category fractions sum to 1', () {
      final data = ReportAggregator.aggregate(
        approvedExpenses: [foodDay1, fuelDay2, foodDay2],
        members: members,
      );
      final sum =
          data.categories.fold<double>(0, (s, c) => s + c.fraction);
      expect(sum, closeTo(1, 1e-9));
    });
  });

  group('aggregate members', () {
    test('computes paid vs owed per member with names', () {
      final data = ReportAggregator.aggregate(
        approvedExpenses: [foodDay1, fuelDay2, foodDay2],
        members: members,
      );

      final amit = data.members.firstWhere((m) => m.memberId == 'm1');
      final prem = data.members.firstWhere((m) => m.memberId == 'm2');
      expect(amit.memberName, 'Amit');
      expect(amit.paidMinor, 140000); // e1 + e3
      expect(amit.owedMinor, 100000); // 50000 + 30000 + 20000
      expect(prem.paidMinor, 60000); // e2
      expect(prem.owedMinor, 100000);
    });
  });

  group('aggregate timeline', () {
    test('groups by day with running cumulative', () {
      final data = ReportAggregator.aggregate(
        approvedExpenses: [foodDay1, fuelDay2, foodDay2],
        members: members,
      );

      expect(data.timeline.length, 2);
      expect(data.timeline[0].date, DateTime(2026, 7));
      expect(data.timeline[0].dailyMinor, 100000);
      expect(data.timeline[0].cumulativeMinor, 100000);
      expect(data.timeline[1].date, DateTime(2026, 7, 2));
      expect(data.timeline[1].dailyMinor, 100000); // fuel 60k + food 40k
      expect(data.timeline[1].cumulativeMinor, 200000);
    });
  });

  group('filters', () {
    test('date range is inclusive of both ends', () {
      final data = ReportAggregator.aggregate(
        approvedExpenses: [foodDay1, fuelDay2, foodDay2],
        members: members,
        filter: ReportFilter(
          start: DateTime(2026, 7, 2),
          end: DateTime(2026, 7, 2),
        ),
      );
      expect(data.expenseCount, 2); // only day-2 expenses
      expect(data.totalMinor, 100000);
    });

    test('category filter narrows to one category', () {
      final data = ReportAggregator.aggregate(
        approvedExpenses: [foodDay1, fuelDay2, foodDay2],
        members: members,
        filter: const ReportFilter(category: ExpenseCategory.fuel),
      );
      expect(data.expenseCount, 1);
      expect(data.categories.single.category, ExpenseCategory.fuel);
    });

    test('member filter matches payer or split participant', () {
      // m2 is in every split, so all three match.
      final all = ReportAggregator.aggregate(
        approvedExpenses: [foodDay1, fuelDay2, foodDay2],
        members: members,
        filter: const ReportFilter(memberId: 'm2'),
      );
      expect(all.expenseCount, 3);

      // A member involved in nothing yields an empty report.
      final none = ReportAggregator.aggregate(
        approvedExpenses: [foodDay1, fuelDay2, foodDay2],
        members: members,
        filter: const ReportFilter(memberId: 'ghost'),
      );
      expect(none.isEmpty, isTrue);
    });
  });

  group('empty', () {
    test('no expenses yields an empty report', () {
      final data = ReportAggregator.aggregate(
        approvedExpenses: const [],
        members: members,
      );
      expect(data.isEmpty, isTrue);
      expect(data.totalMinor, 0);
      expect(data.categories, isEmpty);
    });
  });
}
