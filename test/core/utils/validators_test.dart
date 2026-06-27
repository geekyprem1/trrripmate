import 'package:flutter_test/flutter_test.dart';
import 'package:tripmate/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('rejects malformed', () {
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('a@b'), isNotNull);
    });

    test('accepts valid', () {
      expect(Validators.email('user@example.com'), isNull);
      expect(Validators.email('  user@example.com  '), isNull);
    });
  });

  group('Validators.password', () {
    test('requires at least 8 characters', () {
      expect(Validators.password('1234567'), isNotNull);
      expect(Validators.password('12345678'), isNull);
    });

    test('rejects empty', () {
      expect(Validators.password(''), isNotNull);
    });
  });

  group('Validators.phone', () {
    test('requires E.164 format', () {
      expect(Validators.phone('4155550123'), isNotNull);
      expect(Validators.phone('+14155550123'), isNull);
    });

    test('rejects empty', () {
      expect(Validators.phone(''), isNotNull);
    });
  });

  group('Validators.otp', () {
    test('requires exactly 6 digits', () {
      expect(Validators.otp('123'), isNotNull);
      expect(Validators.otp('1234567'), isNotNull);
      expect(Validators.otp('abcdef'), isNotNull);
      expect(Validators.otp('123456'), isNull);
    });
  });

  group('Validators.displayName', () {
    test('requires 1-60 characters', () {
      expect(Validators.displayName(''), isNotNull);
      expect(Validators.displayName('A' * 61), isNotNull);
      expect(Validators.displayName('Prem'), isNull);
    });
  });
}
