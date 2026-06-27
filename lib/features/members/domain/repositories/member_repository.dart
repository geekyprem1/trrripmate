import 'package:tripmate/core/error/result.dart';
import 'package:tripmate/features/members/domain/entities/invitation.dart';
import 'package:tripmate/features/members/domain/entities/member.dart';

/// Target for a direct invitation (email or phone). Both null = link/code only.
class InviteTarget {
  const InviteTarget({this.email, this.phone});

  final String? email;
  final String? phone;
}

/// Domain boundary for members + invitations (PRD REQ-MEM-01..03, API §5).
///
/// Roster reads stream from the local cache (offline-first). Invitations are
/// online-only (offline rules §14). No exceptions cross this boundary.
abstract interface class MemberRepository {
  /// Active roster for a trip, streamed from the local cache.
  Stream<List<Member>> watchMembers(String tripId);

  /// Pulls the roster from the backend into the cache and keeps it fresh via
  /// realtime. Safe to call offline.
  Future<void> refreshMembers(String tripId);

  /// Removes a member (owner only). Local-first; blocked server-side if the
  /// member has unsettled dues (PRD REQ-MEM-03).
  Future<Result<void>> removeMember({
    required String tripId,
    required String memberId,
  });

  /// Creates an invitation (owner only, online). Returns the shareable invite.
  Future<Result<Invitation>> createInvite({
    required String tripId,
    InviteTarget? target,
  });

  /// Loads a read-only preview of an invitation by code (online).
  Future<Result<InvitePreview>> previewInvite(String code);

  /// Accepts an invitation, joining the trip. Returns the trip id (online).
  Future<Result<String>> acceptInvite(String code);

  /// Rejects an invitation (online).
  Future<Result<void>> rejectInvite(String code);
}
