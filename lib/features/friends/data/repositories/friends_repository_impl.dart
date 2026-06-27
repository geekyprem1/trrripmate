import 'package:drift/drift.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/features/friends/data/datasources/friends_dao.dart';
import 'package:tripmate/features/friends/data/datasources/friends_remote_data_source.dart';
import 'package:tripmate/features/friends/domain/entities/friend.dart';
import 'package:tripmate/features/friends/domain/repositories/friends_repository.dart';
import 'package:uuid/uuid.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  FriendsRepositoryImpl({required FriendsDao dao, required FriendsRemoteDataSource remote})
      : _dao = dao,
        _remote = remote;

  final FriendsDao _dao;
  final FriendsRemoteDataSource _remote;
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
  Future<void> sendFriendRequest(String addresseeId) async {
    await _remote.sendFriendRequest(addresseeId);
    // No local cache write — only accepted friends are cached.
  }

  @override
  Future<void> acceptFriendRequest(String requestId) async {
    await _remote.acceptFriendRequest(requestId);
    // Refresh local cache so the accepted friend appears immediately.
    await refreshFromRemote();
  }

  @override
  Future<void> declineFriendRequest(String requestId) async {
    await _remote.declineFriendRequest(requestId);
  }

  @override
  Future<void> removeFriend(String friendUserId) async {
    await _remote.removeFriend(friendUserId);
    await _dao.remove(friendUserId);
  }

  @override
  Future<void> refreshFromRemote() async {
    final remote = await _remote.fetchAccepted();

    // Upsert every remote accepted friend into local cache.
    for (final r in remote) {
      await _dao.upsert(
        FriendsCompanion.insert(
          id: _uuid.v4(),
          friendUserId: r.friendUserId,
          displayName: r.displayName,
          username: Value(r.username),
          email: Value(r.email),
          avatarUrl: Value(r.avatarUrl),
          addedAt: DateTime.now(),
        ),
      );
    }

    // Remove any locally cached friends that are no longer accepted remotely.
    final remoteIds = remote.map((r) => r.friendUserId).toSet();
    final local = await _dao.getAll();
    for (final row in local) {
      if (!remoteIds.contains(row.friendUserId)) {
        await _dao.remove(row.friendUserId);
      }
    }
  }

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
