import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripmate/features/members/data/models/invitation_dto.dart';

/// Supabase access for invitations via security-definer RPCs (API §5).
///
/// These privileged operations (insert membership, enforce expiry/quota) run
/// server-side; the client never bypasses RLS itself (CLAUDE.md §12/§13).
class InviteRemoteDataSource {
  InviteRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<InvitationDto> createInvite({
    required String tripId,
    String? email,
    String? phone,
  }) async {
    final result = await _client.rpc<dynamic>(
      'invite_create',
      params: {'p_trip_id': tripId, 'p_email': email, 'p_phone': phone},
    );
    return InvitationDto.fromJson(_asRow(result));
  }

  Future<InvitePreviewDto> previewInvite(String code) async {
    final result = await _client.rpc<dynamic>(
      'invite_preview',
      params: {'p_code': code},
    );
    return InvitePreviewDto.fromJson(_asRow(result));
  }

  /// Accepts the invitation and returns the joined trip id.
  Future<String> acceptInvite(String code) async {
    final result = await _client.rpc<dynamic>(
      'invite_accept',
      params: {'p_code': code},
    );
    return _asRow(result)['trip_id'] as String;
  }

  Future<void> rejectInvite(String code) async {
    await _client.rpc<dynamic>('invite_reject', params: {'p_code': code});
  }

  Map<String, dynamic> _asRow(dynamic result) {
    if (result is Map<String, dynamic>) return result;
    if (result is List && result.isNotEmpty) {
      return result.first as Map<String, dynamic>;
    }
    throw const PostgrestException(message: 'Unexpected RPC response');
  }
}
