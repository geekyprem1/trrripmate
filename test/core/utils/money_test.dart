import 'package:flutter_test/flutter_test.dart';
import 'package:tripmate/core/utils/money.dart';

void main() {
  group('Money.tryParseMajorToMinor', () {
    test('parses whole and decimal amounts', () {
      expect(Money.tryParseMajorToMinor('50000'), 5000000);
      expect(Money.tryParseMajorToMinor('1,250.50'), 125050);
      expect(Money.tryParseMajorToMinor('0'), 0);
    });

    test('returns null for blank or invalid', () {
      expect(Money.tryParseMajorToMinor(''), isNull);
      expect(Money.tryParseMajorToMinor('abc'), isNull);
      expect(Money.tryParseMajorToMinor('-5'), isNull);
    });
  });

  group('Money.format', () {
    test('formats whole amounts with grouping and symbol', () {
      expect(Money.format(5000000, 'INR'), '₹50,000');
      expect(Money.format(125050, 'INR'), '₹1,250.50');
    });

    test('falls back to currency code when symbol unknown', () {
      expect(Money.format(100000, 'CHF'), 'CHF 1,000');
    });

    test('handles negative amounts', () {
      expect(Money.format(-50000, 'USD'), r'-$500');
    });
  });
}
