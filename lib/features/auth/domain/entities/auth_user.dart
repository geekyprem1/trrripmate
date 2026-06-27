import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

/// The authenticated identity (maps to Supabase `auth.users`).
///
/// Pure domain entity — no infrastructure types (CLAUDE.md §3).
@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    String? email,
    String? phone,
  }) = _AuthUser;
}
