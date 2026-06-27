import 'package:supabase_flutter/supabase_flutter.dart';

/// A friend relationship fetched from Supabase — the "other" user's profile
/// resolved on the client side (requester or addressee, whichever is not me).
class RemoteFriend {
  const RemoteFriend({
    required this.requestId,
    required this.friendUserId,
    required this.displayName,
    required this.status,
    this.username,
    this.avatarUrl,
    this.email,
  });

  final String requestId;
  final String friendUserId;
  final String displayName;
  final String status; // pending | accepted | declined
  final String? username;
  final String? avatarUrl;
  final String? email;
}

/// Remote data source for the `user_friends` table in Supabase.
/// All methods operate on behalf of the currently signed-in user.
class FriendsRemoteDataSource {
  FriendsRemoteDataSource(this._client);

  static const _table = 'user_friends';
  final SupabaseClient _client;

  String get _myId => _client.auth.currentUser!.id;

  /// Send a friend request to [addresseeId]. Returns the new request ID.
  Future<String> sendFriendRequest(String addresseeId) async {
    final row = await _client
        .from(_table)
        .insert({
          'requester_id': _myId,
          'addressee_id': addresseeId,
          'status': 'pending',
        })
        .select('id')
        .single();
    return row['id'] as String;
  }

  /// Accept a pending friend request by its [requestId].
  Future<void> acceptFriendRequest(String requestId) async {
    await _client
        .from(_table)
        .update({'status': 'accepted'})
        .eq('id', requestId)
        .eq('addressee_id', _myId);
  }

  /// Decline / cancel a friend request by its [requestId].
  Future<void> declineFriendRequest(String requestId) async {
    await _client.from(_table).delete().eq('id', requestId);
  }

  /// Remove an accepted friendship (either as requester or addressee).
  Future<void> removeFriend(String otherUserId) async {
    await _client
        .from(_table)
        .delete()
        .or('and(requester_id.eq.$_myId,addressee_id.eq.$otherUserId),'
            'and(requester_id.eq.$otherUserId,addressee_id.eq.$_myId)');
  }

  /// Returns all accepted friends with their profile data.
  Future<List<RemoteFriend>> fetchAccepted() async {
    final rows = await _client
        .from(_table)
        .select(
          'id, requester_id, addressee_id, status,'
          'requester:profiles!requester_id(id, display_name, username, avatar_url, email),'
          'addressee:profiles!addressee_id(id, display_name, username, avatar_url, email)',
        )
        .eq('status', 'accepted')
        .or('requester_id.eq.$_myId,addressee_id.eq.$_myId');

    return (rows as List).map((r) {
      final isRequester = (r['requester_id'] as String) == _myId;
      final friend =
          (isRequester ? r['addressee'] : r['requester']) as Map<String, dynamic>;
      return RemoteFriend(
        requestId: r['id'] as String,
        friendUserId: friend['id'] as String,
        displayName: (friend['display_name'] as String?) ?? 'Unknown',
        status: r['status'] as String,
        username: friend['username'] as String?,
        avatarUrl: friend['avatar_url'] as String?,
        email: friend['email'] as String?,
      );
    }).toList();
  }

  /// Check if there is an existing relationship (any status) with [otherUserId].
  /// Returns null if none exists.
  Future<Map<String, dynamic>?> checkRelationship(String otherUserId) async {
    final rows = await _client
        .from(_table)
        .select('id, status, requester_id')
        .or('and(requester_id.eq.$_myId,addressee_id.eq.$otherUserId),'
            'and(requester_id.eq.$otherUserId,addressee_id.eq.$_myId)')
        .limit(1);
    if ((rows as List).isEmpty) return null;
    return rows.first as Map<String, dynamic>;
  }
}
