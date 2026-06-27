import 'package:flutter_test/flutter_test.dart';
import 'package:tripmate/features/expenses/domain/entities/expense.dart';
import 'package:tripmate/features/expenses/domain/entities/expense_category.dart';
import 'package:tripmate/features/settlement/domain/entities/member_balance.dart';
import 'package:tripmate/features/settlement/domain/entities/settlement.dart';
import 'package:tripmate/features/settlement/domain/settlement_calculator.dart';

/// Builds an approved expense paid by [paidBy], split into [shares]
/// (memberId → shareMinor). Shares must sum to [amountMinor].
Expense _expense({
  required String paidBy,
  required int amountMinor,
  required Map<String, int> shares,
}) {
  return Expense(
    id: 'e-$paidBy-$amountMinor',
    tripId: 't1',
    paidByMemberId: paidBy,
    amountMinor: amountMinor,
    currency: 'INR',
    category: ExpenseCategory.food,
    date: DateTime(2026, 7),
    status: ExpenseStatus.approved,
    createdBy: 'u1',
    splits: [
      for (final entry in shares.entries)
        ExpenseSplit(memberId: entry.key, shareMinor: entry.value),
    ],
  );
}

Settlement _completed({
  required String from,
  required String to,
  required int amountMinor,
}) {
  return Settlement(
    id: 's-$from-$to',
    tripId: 't1',
    fromMemberId: from,
    toMemberId: to,
    amountMinor: amountMinor,
    status: SettlementStatus.completed,
  );
}

int _sumNet(Iterable<MemberBalance> balances) =>
    balances.fold<int>(0, (sum, b) => sum + b.netMinor);

void main() {
  group('computeNet', () {
    test('payer is credited their outlay minus their own share', () {
      final net = SettlementCalculator.computeNet(
        approvedExpenses: [
          _expense(
            paidBy: 'm1',
            amountMinor: 90000,
            shares: {'m1': 30000, 'm2': 30000, 'm3': 30000},
          ),
        ],
        completedSettlements: const [],
      );

      expect(net['m1'], 60000); // paid 900, owes 300
      expect(net['m2'], -30000);
      expect(net['m3'], -30000);
    });

    test('completed settlement discharges the debt (reopen basis)', () {
      final expenses = [
        _expense(
          paidBy: 'm1',
          amountMinor: 100000,
          shares: {'m1': 50000, 'm2': 50000},
        ),
      ];

      final net = SettlementCalculator.computeNet(
        approvedExpenses: expenses,
        completedSettlements: [
          _completed(from: 'm2', to: 'm1', amountMinor: 50000),
        ],
      );

      // m2 paid m1 the 500 they owed → everyone is square.
      expect(net.isEmpty, isTrue);
    });
  });

  group('summarize — zero-sum invariant', () {
    test('balances always net to zero', () {
      final summary = SettlementCalculator.summarize(
        approvedExpenses: [
          _expense(
            paidBy: 'm1',
            amountMinor: 90000,
            shares: {'m1': 30000, 'm2': 30000, 'm3': 30000},
          ),
          _expense(
            paidBy: 'm2',
            amountMinor: 30000,
            shares: {'m1': 10000, 'm2': 10000, 'm3': 10000},
          ),
        ],
        completedSettlements: const [],
        activeMemberIds: const ['m1', 'm2', 'm3'],
      );

      expect(_sumNet(summary.balances), 0);
    });

    test('outstanding transfers sum to the total owed', () {
      final summary = SettlementCalculator.summarize(
        approvedExpenses: [
          _expense(
            paidBy: 'm1',
            amountMinor: 90000,
            shares: {'m1': 30000, 'm2': 30000, 'm3': 30000},
          ),
        ],
        completedSettlements: const [],
        activeMemberIds: const ['m1', 'm2', 'm3'],
      );

      final total = summary.transactions
          .fold<int>(0, (sum, t) => sum + t.amountMinor);
      expect(total, 60000);
      // m2 and m3 each pay m1 their 300 share.
      expect(summary.transactions.length, 2);
      expect(summary.transactions.every((t) => t.toMemberId == 'm1'), isTrue);
    });
  });

  group('summarize — edge cases (REQ-SET-01)', () {
    test('single member: no transactions', () {
      final summary = SettlementCalculator.summarize(
        approvedExpenses: [
          _expense(paidBy: 'm1', amountMinor: 50000, shares: {'m1': 50000}),
        ],
        completedSettlements: const [],
        activeMemberIds: const ['m1'],
      );

      expect(summary.transactions, isEmpty);
      expect(summary.isAllSettled, isTrue);
    });

    test('everyone paid equally: no transactions', () {
      final summary = SettlementCalculator.summarize(
        approvedExpenses: [
          _expense(
            paidBy: 'm1',
            amountMinor: 100000,
            shares: {'m1': 50000, 'm2': 50000},
          ),
          _expense(
            paidBy: 'm2',
            amountMinor: 100000,
            shares: {'m1': 50000, 'm2': 50000},
          ),
        ],
        completedSettlements: const [],
        activeMemberIds: const ['m1', 'm2'],
      );

      expect(summary.transactions, isEmpty);
      expect(summary.isAllSettled, isTrue);
    });

    test('removed member with a balance still appears and settles', () {
      // m2 was removed (not in activeMemberIds) but still owes m1.
      final summary = SettlementCalculator.summarize(
        approvedExpenses: [
          _expense(
            paidBy: 'm1',
            amountMinor: 100000,
            shares: {'m1': 50000, 'm2': 50000},
          ),
        ],
        completedSettlements: const [],
        activeMemberIds: const ['m1'],
      );

      expect(summary.balances.map((b) => b.memberId), contains('m2'));
      expect(summary.transactions.length, 1);
      expect(summary.transactions.single.fromMemberId, 'm2');
      expect(summary.transactions.single.toMemberId, 'm1');
      expect(summary.transactions.single.amountMinor, 50000);
    });

    test('no expenses: empty (nothing to settle)', () {
      final summary = SettlementCalculator.summarize(
        approvedExpenses: const [],
        completedSettlements: const [],
        activeMemberIds: const ['m1', 'm2'],
      );

      expect(summary.isEmpty, isTrue);
      expect(summary.isAllSettled, isFalse);
      expect(summary.transactions, isEmpty);
    });
  });

  group('summarize — reopen + your-net', () {
    test('a completed payment clears the graph; a new expense reopens it', () {
      final firstExpense = _expense(
        paidBy: 'm1',
        amountMinor: 100000,
        shares: {'m1': 50000, 'm2': 50000},
      );

      final settled = SettlementCalculator.summarize(
        approvedExpenses: [firstExpense],
        completedSettlements: [
          _completed(from: 'm2', to: 'm1', amountMinor: 50000),
        ],
        activeMemberIds: const ['m1', 'm2'],
      );
      expect(settled.isAllSettled, isTrue);

      final reopened = SettlementCalculator.summarize(
        approvedExpenses: [
          firstExpense,
          _expense(
            paidBy: 'm1',
            amountMinor: 40000,
            shares: {'m1': 20000, 'm2': 20000},
          ),
        ],
        completedSettlements: [
          _completed(from: 'm2', to: 'm1', amountMinor: 50000),
        ],
        activeMemberIds: const ['m1', 'm2'],
      );

      expect(reopened.isAllSettled, isFalse);
      expect(reopened.transactions.single.amountMinor, 20000);
      expect(reopened.transactions.single.fromMemberId, 'm2');
    });

    test('yourNet reflects the current member (negative = you owe)', () {
      final summary = SettlementCalculator.summarize(
        approvedExpenses: [
          _expense(
            paidBy: 'm1',
            amountMinor: 100000,
            shares: {'m1': 50000, 'm2': 50000},
          ),
        ],
        completedSettlements: const [],
        activeMemberIds: const ['m1', 'm2'],
        currentMemberId: 'm2',
      );

      expect(summary.yourNetMinor, -50000);
    });
  });
}
