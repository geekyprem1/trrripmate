import 'package:tripmate/features/expenses/domain/entities/expense.dart';

/// Pure split computation (PRD REQ-EXP-05). v1.0 supports equal split only; the
/// rounding remainder goes to the payer so splits always sum to the amount
/// exactly (CLAUDE.md §13 — integer money, no float).
abstract final class SplitCalculator {
  /// Splits [amountMinor] equally across [memberIds]; any remainder is added to
  /// the [payerMemberId] (who must be in [memberIds], else the first member).
  static List<ExpenseSplit> equalSplit({
    required int amountMinor,
    required List<String> memberIds,
    required String payerMemberId,
  }) {
    if (memberIds.isEmpty) return const [];

    final base = amountMinor ~/ memberIds.length;
    final remainder = amountMinor - base * memberIds.length;
    final remainderHolder =
        memberIds.contains(payerMemberId) ? payerMemberId : memberIds.first;

    return [
      for (final memberId in memberIds)
        ExpenseSplit(
          memberId: memberId,
          shareMinor: memberId == remainderHolder ? base + remainder : base,
        ),
    ];
  }

  /// True when the splits sum exactly to [amountMinor] (validation invariant).
  static bool sumsToAmount(List<ExpenseSplit> splits, int amountMinor) {
    final total = splits.fold<int>(0, (sum, s) => sum + s.shareMinor);
    return total == amountMinor;
  }
}
