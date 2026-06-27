import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';

/// A member's role within a trip (DB Design §4.3). `admin` is reserved (v1.5).
enum MemberRole { owner, member, admin }

/// A trip member (DB Design §4.3). Display fields are denormalized from the
/// member's profile for roster rendering.
@freezed
class Member with _$Member {
  const factory Member({
    required String id,
    required String tripId,
    required String userId,
    required MemberRole role,
    required DateTime joinedAt,
    @Default(false) bool isPendingSync,
    String? displayName,
    String? avatarUrl,
  }) = _Member;

  const Member._();

  bool get isOwner => role == MemberRole.owner;
}
