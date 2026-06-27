import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripmate/features/members/data/models/member_dto.dart';

/// Supabase access for the roster (DB Design §4.3). Only this source touches the
/// SDK (CLAUDE.md §12). Throws on error; the caller maps to typed failures.
class MemberRemoteDataSource {
  MemberRemoteDataSource(this._client);

  static const _table = 'trip_members';

  final SupabaseClient _client;

  /// Fetches the active roster with each member's profile display fields.
  Future<List<MemberDto>> fetchMembers(String tripId) async {
    final rows = await _client
        .from(_table)
        .select('*, profiles(display_name, avatar_url)')
        .eq('trip_id', tripId)
        .eq('status', 'active');
    return rows.map(MemberDto.fromJson).toList();
  }

  /// Realtime signal stream for roster changes on a trip. Emits on every
  /// change; callers re-fetch the joined roster (Architecture §9).
  Stream<void> watchRosterChanges(String tripId) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('trip_id', tripId)
        .map((_) {});
  }

  /// Removes a member via the `remove_member` RPC (owner only, dues-checked).
  Future<void> removeMember({
    required String tripId,
    required String memberId,
  }) async {
    await _client.rpc<dynamic>(
      'remove_member',
      params: {'p_trip_id': tripId, 'p_member_id': memberId},
    );
  }
}
