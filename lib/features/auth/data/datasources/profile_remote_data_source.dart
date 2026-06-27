import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripmate/features/auth/data/models/profile_dto.dart';

/// Reads/writes the `profiles` table under RLS (Data Design §4.1, §9).
class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._client);

  static const _table = 'profiles';

  final SupabaseClient _client;

  /// Returns the current user's profile row, or `null` if none exists.
  Future<ProfileDto?> fetchProfile(String userId) async {
    final row =
        await _client.from(_table).select().eq('id', userId).maybeSingle();
    if (row == null) return null;
    return ProfileDto.fromJson(row);
  }

  /// Inserts or updates the current user's profile and returns the saved row.
  Future<ProfileDto> upsertProfile(ProfileDto dto) async {
    final row =
        await _client.from(_table).upsert(dto.toJson()).select().single();
    return ProfileDto.fromJson(row);
  }

  /// Looks up a profile by username (case-insensitive). Returns `null` when not
  /// found so callers can surface a "user not found" failure cleanly.
  Future<ProfileDto?> findProfileByUsername(String username) async {
    final row = await _client
        .from(_table)
        .select()
        .ilike('username', username)
        .maybeSingle();
    if (row == null) return null;
    return ProfileDto.fromJson(row);
  }
}
