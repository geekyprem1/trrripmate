import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripmate/core/error/failure.dart';

/// Maps raw data-source errors to typed [Failure]s at the data edge so no
/// exceptions cross the repository boundary (CLAUDE.md §6, API §13).
Failure mapAuthError(Object error) {
  if (error is AuthException) {
    return _fromAuthException(error);
  }
  if (error is PostgrestException) {
    // RLS denial surfaces as a permission failure; everything else is unknown.
    if (error.code == '42501' || error.code == 'PGRST301') {
      return const Failure.permission();
    }
    return Failure.unknown(message: error.message);
  }
  return const Failure.unknown();
}

Failure _fromAuthException(AuthException error) {
  final message = error.message;
  final lower = message.toLowerCase();

  if (lower.contains('invalid login') ||
      lower.contains('invalid credentials')) {
    return const Failure.auth(
      message: 'Email or password is incorrect.',
      code: 'AUTH_INVALID_CREDENTIALS',
    );
  }
  if (lower.contains('otp') || lower.contains('token has expired')) {
    return const Failure.auth(
      message: 'Incorrect or expired code.',
      code: 'AUTH_OTP_INVALID',
    );
  }
  if (lower.contains('already registered') || lower.contains('user already')) {
    return const Failure.auth(
      message: 'This email is already registered.',
      code: 'AUTH_EMAIL_TAKEN',
    );
  }
  if (lower.contains('rate limit') || lower.contains('too many')) {
    return const Failure.auth(
      message: 'Too many attempts. Please wait and try again.',
      code: 'AUTH_OTP_THROTTLED',
    );
  }
  return Failure.auth(message: message);
}
