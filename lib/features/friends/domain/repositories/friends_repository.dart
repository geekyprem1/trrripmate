import 'package:tripmate/features/friends/domain/entities/friend.dart';

abstract interface class FriendsRepository {
  Stream<List<Friend>> watchFriends();
  Future<List<Friend>> getFriends();
  Future<bool> isFriend(String friendUserId);
  Future<void> addFriend({
    required String friendUserId,
    required String displayName,
    String? username,
    String? email,
    String? avatarUrl,
  });
  Future<void> removeFriend(String friendUserId);
}
