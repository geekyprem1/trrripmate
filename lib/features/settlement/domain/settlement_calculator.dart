import 'package:tripmate/features/expenses/domain/entities/expense.dart';
import 'package:tripmate/features/settlement/domain/entities/member_balance.dart';
import 'package:tripmate/features/settlement/domain/entities/settlement.dart';
import 'package:tripmate/features/settlement/domain/entities/settlement_summary.dart';

/// Pure settlement computation (PRD REQ-SET-01). Derives net balances from
/// approved expenses (adjusted by already-completed payments) and the minimal
/// set of "who pays who" transactions that clears them.
///
/// Money is integer minor units — no float (CLAUDE.md §13). The greedy
/// debtor↔creditor matching yields at most `n − 1` transactions and the net of
/// all balances is exactly zero by construction (zero-sum invariant).
abstract final class SettlementCalculator {
  /// Builds the [SettlementSummary] for a trip.
  ///
  /// [approvedExpenses] feed the raw balances; [completedSettlements] discharge
  /// debts already paid (so they drop out of the outstanding graph and a new
  /// expense reopens it). [activeMemberIds] are always represented in the
  /// balances; removed members still appear if they carry a non-zero balance.
  static SettlementSummary summarize({
    required List<Expense> approvedExpenses,
    required List<Settlement> completedSettlements,
    required List<String> activeMemberIds,
    String? currentMemberId,
  }) {
    final net = computeNet(
      approvedExpenses: approvedExpenses,
      completedSettlements: completedSettlements,
    );

    // Balances: every active member (even settled) plus any non-active member
    // who still carries a balance (removed-member edge case, REQ-SET-01).
    final memberIds = <String>{...activeMemberIds, ...net.keys};
    final balances = [
      for (final id in memberIds.toList()..sort())
        MemberBalance(memberId: id, netMinor: net[id] ?? 0),
    ];

    final tripId = approvedExpenses.isNotEmpty
        ? approvedExpenses.first.tripId
        : (completedSettlements.isNotEmpty
            ? completedSettlements.first.tripId
            : '');

    return SettlementSummary(
      balances: balances,
      transactions: minimize(net, tripId: tripId),
      yourNetMinor: currentMemberId == null ? 0 : (net[currentMemberId] ?? 0),
      hasActivity: approvedExpenses.isNotEmpty,
    );
  }

  /// Net position per member (minor units): Σ paid − Σ share over approved
  /// expenses, then `+amount` to each completed payment's debtor and `−amount`
  /// to its creditor (already-settled money). Members that net to zero are
  /// omitted from the map.
  static Map<String, int> computeNet({
    required List<Expense> approvedExpenses,
    required List<Settlement> completedSettlements,
  }) {
    final net = <String, int>{};
    void add(String memberId, int delta) {
      net[memberId] = (net[memberId] ?? 0) + delta;
    }

    for (final expense in approvedExpenses) {
      add(expense.paidByMemberId, expense.amountMinor);
      for (final split in expense.splits) {
        add(split.memberId, -split.shareMinor);
      }
    }

    for (final paid in completedSettlements) {
      // The debtor has discharged this much; the creditor has received it.
      add(paid.fromMemberId, paid.amountMinor);
      add(paid.toMemberId, -paid.amountMinor);
    }

    net.removeWhere((_, value) => value == 0);
    return net;
  }

  /// Greedy minimal "who pays who": repeatedly match the largest debtor with
  /// the largest creditor. Deterministic (ties broken by member id) so results
  /// are reproducible and testable.
  static List<Settlement> minimize(
    Map<String, int> net, {
    required String tripId,
  }) {
    final debtors = <MapEntry<String, int>>[];
    final creditors = <MapEntry<String, int>>[];
    for (final entry in net.entries) {
      if (entry.value < 0) {
        debtors.add(MapEntry(entry.key, -entry.value));
      } else if (entry.value > 0) {
        creditors.add(MapEntry(entry.key, entry.value));
      }
    }

    int byAmountDescThenId(MapEntry<String, int> a, MapEntry<String, int> b) {
      final byAmount = b.value.compareTo(a.value);
      return byAmount != 0 ? byAmount : a.key.compareTo(b.key);
    }

    debtors.sort(byAmountDescThenId);
    creditors.sort(byAmountDescThenId);

    final transactions = <Settlement>[];
    var i = 0;
    var j = 0;
    var owe = debtors.isEmpty ? 0 : debtors[i].value;
    var cred = creditors.isEmpty ? 0 : creditors[j].value;

    while (i < debtors.length && j < creditors.length) {
      final transfer = owe < cred ? owe : cred;
      transactions.add(
        Settlement(
          tripId: tripId,
          fromMemberId: debtors[i].key,
          toMemberId: creditors[j].key,
          amountMinor: transfer,
          status: SettlementStatus.pending,
        ),
      );
      owe -= transfer;
      cred -= transfer;
      if (owe == 0) {
        i++;
        if (i < debtors.length) owe = debtors[i].value;
      }
      if (cred == 0) {
        j++;
        if (j < creditors.length) cred = creditors[j].value;
      }
    }

    return transactions;
  }
}
