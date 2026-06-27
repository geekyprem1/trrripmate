import 'package:drift/drift.dart';
import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/core/database/tables.dart';

part 'member_dao.g.dart';

/// Local (Drift) access for trip members — roster read source (Architecture §6).
@DriftAccessor(tables: [Members])
class MemberDao extends DatabaseAccessor<AppDatabase> with _$MemberDaoMixin {
  MemberDao(super.db);

  Stream<List<MemberRow>> watchMembers(String tripId) {
    return (select(members)
          ..where((m) => m.tripId.equals(tripId) & m.status.equals('active'))
          ..orderBy([(m) => OrderingTerm.asc(m.joinedAt)]))
        .watch();
  }

  Future<MemberRow?> getMember(String id) {
    return (select(members)..where((m) => m.id.equals(id))).getSingleOrNull();
  }

  /// The membership row for a given user in a trip (used for role checks).
  Future<MemberRow?> getMemberForUser(String tripId, String userId) {
    return (select(members)
          ..where((m) => m.tripId.equals(tripId) & m.userId.equals(userId)))
        .getSingleOrNull();
  }

  /// Active members of a trip who still owe / are owed — used to block removal
  /// (PRD REQ-MEM-03). Dues data arrives in Sprint 5; for now this is roster.
  Future<int> activeMemberCount(String tripId) async {
    final count = countAll();
    final query = selectOnly(members)
      ..addColumns([count])
      ..where(members.tripId.equals(tripId) & members.status.equals('active'));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<void> upsertMember(MemberRow row) {
    return into(members).insertOnConflictUpdate(row);
  }

  /// Replaces the cached roster for a trip with the freshly pulled rows. Member
  /// mutations are online (PRD REQ-MEM-03), so there are no local-pending rows
  /// to preserve.
  Future<void> replaceForTrip(String tripId, List<MemberRow> rows) async {
    await transaction(() async {
      await (delete(members)..where((m) => m.tripId.equals(tripId))).go();
      await batch((b) => b.insertAll(members, rows));
    });
  }
}
