import 'package:drift/drift.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/database/tables.dart';

part 'friends_dao.g.dart';

@DriftAccessor(tables: [Friends])
class FriendsDao extends DatabaseAccessor<AppDatabase> with _$FriendsDaoMixin {
  FriendsDao(super.db);

  Stream<List<FriendRow>> watchAll() =>
      (select(friends)..orderBy([(f) => OrderingTerm.asc(f.displayName)]))
          .watch();

  Future<List<FriendRow>> getAll() =>
      (select(friends)..orderBy([(f) => OrderingTerm.asc(f.displayName)]))
          .get();

  Future<bool> isFriend(String friendUserId) async {
    final row = await (select(friends)
          ..where((f) => f.friendUserId.equals(friendUserId)))
        .getSingleOrNull();
    return row != null;
  }

  Future<void> upsert(FriendsCompanion row) =>
      into(friends).insertOnConflictUpdate(row);

  Future<void> remove(String friendUserId) =>
      (delete(friends)..where((f) => f.friendUserId.equals(friendUserId))).go();
}
