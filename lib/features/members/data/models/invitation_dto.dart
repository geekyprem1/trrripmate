import 'package:tripmate/features/members/domain/entities/invitation.dart';

InvitationStatus invitationStatusFromString(String value) {
  return switch (value) {
    'accepted' => InvitationStatus.accepted,
    'rejected' => InvitationStatus.rejected,
    'expired' => InvitationStatus.expired,
    _ => InvitationStatus.pending,
  };
}

/// Wire model for an `invitations` row (DB Design §4.4, API §5.1).
class InvitationDto {
  const InvitationDto({
    required this.id,
    required this.tripId,
    required this.code,
    required this.status,
    required this.expiresAt,
  });

  factory InvitationDto.fromJson(Map<String, dynamic> json) {
    return InvitationDto(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      code: json['invite_code'] as String,
      status: json['status'] as String? ?? 'pending',
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  final String id;
  final String tripId;
  final String code;
  final String status;
  final DateTime expiresAt;

  Invitation toEntity() {
    return Invitation(
      id: id,
      tripId: tripId,
      code: code,
      status: invitationStatusFromString(status),
      expiresAt: expiresAt,
    );
  }
}

/// Wire model for the `invite_preview` RPC result (UI/UX §3.13).
class InvitePreviewDto {
  const InvitePreviewDto({
    required this.code,
    required this.tripName,
    required this.status,
    required this.expiresAt,
    required this.memberCount,
    this.ownerName,
  });

  factory InvitePreviewDto.fromJson(Map<String, dynamic> json) {
    return InvitePreviewDto(
      code: json['invite_code'] as String? ?? json['code'] as String,
      tripName: json['trip_name'] as String,
      status: json['status'] as String? ?? 'pending',
      expiresAt: DateTime.parse(json['expires_at'] as String),
      memberCount: (json['member_count'] as num?)?.toInt() ?? 0,
      ownerName: json['owner_name'] as String?,
    );
  }

  final String code;
  final String tripName;
  final String status;
  final DateTime expiresAt;
  final int memberCount;
  final String? ownerName;

  InvitePreview toEntity() {
    return InvitePreview(
      code: code,
      tripName: tripName,
      status: invitationStatusFromString(status),
      expiresAt: expiresAt,
      memberCount: memberCount,
      ownerName: ownerName,
    );
  }
}
