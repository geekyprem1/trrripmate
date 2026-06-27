import 'package:drift/drift.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/features/friends/data/datasources/friends_dao.dart';
import 'package:tripmate/features/friends/domain/entities/friend.dart';
import 'package:tripmate/features/friends/domain/repositories/friends_repository.dart';
import 'package:uuid/uuid.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  FriendsRepositoryImpl(this._dao);

  final FriendsDao _dao;
  final _uuid = const Uuid();

  @override
  Stream<List<Friend>> watchFriends() =>
      _dao.watchAll().map((rows) => [for (final r in rows) _toEntity(r)]);

  @override
  Future<List<Friend>> getFriends() async {
    final rows = await _dao.getAll();
    return [for (final r in rows) _toEntity(r)];
  }

  @override
  Future<bool> isFriend(String friendUserId) => _dao.isFriend(friendUserId);

  @override
  Future<void> addFriend({
    required String friendUserId,
    required String displayName,
    String? username,
    String? email,
    String? avatarUrl,
  }) =>
      _dao.upsert(
        FriendsCompanion.insert(
          id: _uuid.v4(),
          friendUserId: friendUserId,
          displayName: displayName,
          username: Value(username),
          email: Value(email),
          avatarUrl: Value(avatarUrl),
          addedAt: DateTime.now(),
        ),
      );

  @override
  Future<void> removeFriend(String friendUserId) =>
      _dao.remove(friendUserId);

  Friend _toEntity(FriendRow r) => Friend(
        id: r.id,
        friendUserId: r.friendUserId,
        displayName: r.displayName,
        username: r.username,
        avatarUrl: r.avatarUrl,
        email: r.email,
        addedAt: r.addedAt,
      );
}
