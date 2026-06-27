import 'package:tripmate/features/friends/domain/entities/friend.dart';

abstract interface class FriendsRepository {
  /// Stream of accepted friends from local cache (offline-capable).
  Stream<List<Friend>> watchFriends();

  Future<List<Friend>> getFriends();

  Future<bool> isFriend(String friendUserId);

  /// Send a friend request to [addresseeId] via Supabase.
  /// The other user will receive a notification.
  Future<void> sendFriendRequest(String addresseeId);

  /// Accept an incoming friend request (called from the notifications screen).
  Future<void> acceptFriendRequest(String requestId);

  /// Decline or cancel a friend request.
  Future<void> declineFriendRequest(String requestId);

  /// Remove an accepted friend (both local cache and Supabase).
  Future<void> removeFriend(String friendUserId);

  /// Pull accepted friends from Supabase and sync to local cache.
  Future<void> refreshFromRemote();
}
