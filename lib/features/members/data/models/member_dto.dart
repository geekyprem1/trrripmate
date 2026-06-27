import 'package:tripmate/core/database/app_database.dart';
import 'package:tripmate/features/members/domain/entities/member.dart';

/// Wire model for a `trip_members` row with embedded profile display fields
/// (DB Design §4.3; selected with `profiles(display_name, avatar_url)`).
class MemberDto {
  const MemberDto({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.role,
    required this.status,
    required this.joinedAt,
    this.displayName,
    this.avatarUrl,
  });

  factory MemberDto.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'];
    final profileMap = profile is Map<String, dynamic> ? profile : null;
    return MemberDto(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String? ?? 'member',
      status: json['status'] as String? ?? 'active',
      joinedAt: DateTime.parse(json['joined_at'] as String),
      displayName: profileMap?['display_name'] as String?,
      avatarUrl: profileMap?['avatar_url'] as String?,
    );
  }

  final String id;
  final String tripId;
  final String userId;
  final String role;
  final String status;
  final DateTime joinedAt;
  final String? displayName;
  final String? avatarUrl;

  MemberRow toRow() {
    return MemberRow(
      id: id,
      tripId: tripId,
      userId: userId,
      role: role,
      status: status,
      displayName: displayName,
      avatarUrl: avatarUrl,
      joinedAt: joinedAt,
      updatedAt: DateTime.now(),
      syncStatus: 'synced',
    );
  }
}

/// Maps a Drift member row to the domain entity.
extension MemberRowMapper on MemberRow {
  Member toEntity() {
    return Member(
      id: id,
      tripId: tripId,
      userId: userId,
      role: _roleFromString(role),
      joinedAt: joinedAt,
      isPendingSync: syncStatus != 'synced',
      displayName: displayName,
      avatarUrl: avatarUrl,
    );
  }
}

MemberRole _roleFromString(String value) {
  return switch (value) {
    'owner' => MemberRole.owner,
    'admin' => MemberRole.admin,
    _ => MemberRole.member,
  };
}
