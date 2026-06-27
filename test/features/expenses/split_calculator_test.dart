import 'package:flutter_test/flutter_test.dart';
import 'package:tripmate/features/expenses/domain/split_calculator.dart';

void main() {
  group('SplitCalculator.equalSplit', () {
    test('divides evenly when there is no remainder', () {
      final splits = SplitCalculator.equalSplit(
        amountMinor: 90000,
        memberIds: ['a', 'b', 'c'],
        payerMemberId: 'a',
      );
      expect(splits.map((s) => s.shareMinor), [30000, 30000, 30000]);
      expect(SplitCalculator.sumsToAmount(splits, 90000), isTrue);
    });

    test('gives the remainder to the payer', () {
      final splits = SplitCalculator.equalSplit(
        amountMinor: 100000,
        memberIds: ['a', 'b', 'c'],
        payerMemberId: 'b',
      );
      // 100000 / 3 = 33333 base, remainder 1 → payer b gets 33334.
      final byMember = {for (final s in splits) s.memberId: s.shareMinor};
      expect(byMember['a'], 33333);
      expect(byMember['b'], 33334);
      expect(byMember['c'], 33333);
      expect(SplitCalculator.sumsToAmount(splits, 100000), isTrue);
    });

    test('remainder falls to the first member when payer is excluded', () {
      final splits = SplitCalculator.equalSplit(
        amountMinor: 100,
        memberIds: ['a', 'b', 'c'],
        payerMemberId: 'z',
      );
      final byMember = {for (final s in splits) s.memberId: s.shareMinor};
      expect(byMember['a'], 34);
      expect(SplitCalculator.sumsToAmount(splits, 100), isTrue);
    });

    test('single member takes the whole amount', () {
      final splits = SplitCalculator.equalSplit(
        amountMinor: 5000,
        memberIds: ['a'],
        payerMemberId: 'a',
      );
      expect(splits.single.shareMinor, 5000);
    });

    test('empty members yields no splits', () {
      final splits = SplitCalculator.equalSplit(
        amountMinor: 5000,
        memberIds: const [],
        payerMemberId: 'a',
      );
      expect(splits, isEmpty);
    });
  });
}
