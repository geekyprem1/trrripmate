/// Pure input validators (PRD §4.1 validation rules, UI/UX §3).
///
/// Each returns `null` when valid, or a user-facing error message when invalid.
/// Pure functions — unit tested directly (CLAUDE.md §7).
abstract final class Validators {
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}'
    r'[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$',
  );

  // E.164: leading + and 8–15 digits.
  static final _phoneRegex = RegExp(r'^\+[1-9]\d{7,14}$');

  /// Email must be present and RFC-shaped.
  static String? email(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'Email is required.';
    if (!_emailRegex.hasMatch(input)) return 'Enter a valid email address.';
    return null;
  }

  /// Password must be at least 8 characters (PRD §4.1).
  static String? password(String? value) {
    final input = value ?? '';
    if (input.isEmpty) return 'Password is required.';
    if (input.length < 8) return 'Password must be at least 8 characters.';
    return null;
  }

  /// Phone must be in E.164 format.
  static String? phone(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'Phone number is required.';
    if (!_phoneRegex.hasMatch(input)) {
      return 'Enter a valid phone number, e.g. +14155550123.';
    }
    return null;
  }

  /// OTP must be exactly 6 digits.
  static String? otp(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'Enter the code.';
    if (!RegExp(r'^\d{6}$').hasMatch(input)) return 'Enter the 6-digit code.';
    return null;
  }

  /// Display name must be 1–60 characters (PRD §4 / Data Design §7.1).
  static String? displayName(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'Name is required.';
    if (input.length > 60) return 'Name must be 60 characters or fewer.';
    return null;
  }
}
