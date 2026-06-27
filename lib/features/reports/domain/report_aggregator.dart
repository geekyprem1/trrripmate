import 'package:tripmate/features/expenses/domain/entities/expense.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';
import 'package:tripmate/features/members/domain/entities/member.dart';
import 'package:tripmate/features/reports/domain/entities/report_data.dart';
import 'package:tripmate/features/reports/domain/entities/report_filter.dart';

/// Pure client-side report aggregation (REQ-REP-01, PRD §12) over approved,
/// non-deleted expenses. Money stays in integer minor units (CLAUDE.md §13).
/// Deterministic ordering so charts, tables and the PDF all agree.
abstract final class ReportAggregator {
  /// Whether [expense] passes the [filter] (inclusive date range; member is
  /// payer or a split participant; exact category).
  static bool matches(Expense expense, ReportFilter filter) {
    final day = _dateOnly(expense.date);
    if (filter.start != null && day.isBefore(_dateOnly(filter.start!))) {
      return false;
    }
    if (filter.end != null && day.isAfter(_dateOnly(filter.end!))) {
      return false;
    }
    if (filter.category != null && expense.category != filter.category) {
      return false;
    }
    if (filter.memberId != null) {
      final involved = expense.paidByMemberId == filter.memberId ||
          expense.splits.any((s) => s.memberId == filter.memberId);
      if (!involved) return false;
    }
    return true;
  }

  /// Builds [ReportData] from the filtered approved expenses, resolving member
  /// names from [members] (so the result is self-contained for PDF export).
  static ReportData aggregate({
    required List<Expense> approvedExpenses,
    required List<Member> members,
    ReportFilter filter = const ReportFilter(),
  }) {
    final filtered =
        approvedExpenses.where((e) => matches(e, filter)).toList();
    if (filtered.isEmpty) return const ReportData();

    final total = filtered.fold<int>(0, (sum, e) => sum + e.amountMinor);
    final names = {for (final m in members) m.id: m.displayName ?? 'Member'};

    return ReportData(
      totalMinor: total,
      expenseCount: filtered.length,
      categories: _categories(filtered, total),
      members: _members(filtered, names),
      timeline: _timeline(filtered),
    );
  }

  static List<CategorySlice> _categories(List<Expense> expenses, int total) {
    final sums = <ExpenseCategory, int>{};
    for (final e in expenses) {
      sums[e.category] = (sums[e.category] ?? 0) + e.amountMinor;
    }
    final slices = [
      for (final entry in sums.entries)
        CategorySlice(
          category: entry.key,
          amountMinor: entry.value,
          fraction: total == 0 ? 0 : entry.value / total,
        ),
    ]..sort((a, b) {
        final byAmount = b.amountMinor.compareTo(a.amountMinor);
        return byAmount != 0
            ? byAmount
            : a.category.name.compareTo(b.category.name);
      });
    return slices;
  }

  static List<MemberSpend> _members(
    List<Expense> expenses,
    Map<String, String> names,
  ) {
    final paid = <String, int>{};
    final owed = <String, int>{};
    for (final e in expenses) {
      paid[e.paidByMemberId] = (paid[e.paidByMemberId] ?? 0) + e.amountMinor;
      for (final s in e.splits) {
        owed[s.memberId] = (owed[s.memberId] ?? 0) + s.shareMinor;
      }
    }
    final memberIds = <String>{...paid.keys, ...owed.keys};
    final spends = [
      for (final id in memberIds)
        MemberSpend(
          memberId: id,
          memberName: names[id] ?? 'Member',
          paidMinor: paid[id] ?? 0,
          owedMinor: owed[id] ?? 0,
        ),
    ]..sort((a, b) {
        final byPaid = b.paidMinor.compareTo(a.paidMinor);
        return byPaid != 0 ? byPaid : a.memberName.compareTo(b.memberName);
      });
    return spends;
  }

  static List<TimelinePoint> _timeline(List<Expense> expenses) {
    final daily = <DateTime, int>{};
    for (final e in expenses) {
      final day = _dateOnly(e.date);
      daily[day] = (daily[day] ?? 0) + e.amountMinor;
    }
    final days = daily.keys.toList()..sort();
    var cumulative = 0;
    return [
      for (final day in days)
        () {
          cumulative += daily[day]!;
          return TimelinePoint(
            date: day,
            dailyMinor: daily[day]!,
            cumulativeMinor: cumulative,
          );
        }(),
    ];
  }

  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
