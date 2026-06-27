import 'package:freezed_annotation/freezed_annotation.dart';

part 'invitation.freezed.dart';

/// Invitation lifecycle status (DB Design §4.4).
enum InvitationStatus { pending, accepted, rejected, expired }

/// An invitation created by an owner (DB Design §4.4, API §5.1).
@freezed
class Invitation with _$Invitation {
  const factory Invitation({
    required String id,
    required String tripId,
    required String code,
    required InvitationStatus status,
    required DateTime expiresAt,
  }) = _Invitation;

  const Invitation._();

  /// Shareable deep link for the invite (UI/UX §3.12).
  String get deepLink => 'https://tripmate.app/invite/$code';
}

/// Read-only preview shown on the Join screen before accepting (UI/UX §3.13).
@freezed
class InvitePreview with _$InvitePreview {
  const factory InvitePreview({
    required String code,
    required String tripName,
    required InvitationStatus status,
    required DateTime expiresAt,
    required int memberCount,
    String? ownerName,
  }) = _InvitePreview;

  const InvitePreview._();

  bool get isExpired =>
      status == InvitationStatus.expired || DateTime.now().isAfter(expiresAt);

  bool get isOpen => status == InvitationStatus.pending && !isExpired;
}
