import 'package:flutter_test/flutter_test.dart';
import 'package:tripmate/features/members/domain/entities/invitation.dart';

void main() {
  InvitePreview preview({
    required InvitationStatus status,
    required Duration expiresIn,
  }) {
    return InvitePreview(
      code: 'abc',
      tripName: 'Goa',
      status: status,
      expiresAt: DateTime.now().add(expiresIn),
      memberCount: 2,
    );
  }

  test('isOpen is true for a pending, unexpired invite', () {
    final p = preview(
      status: InvitationStatus.pending,
      expiresIn: const Duration(days: 3),
    );
    expect(p.isOpen, isTrue);
    expect(p.isExpired, isFalse);
  });

  test('isExpired is true once the deadline has passed', () {
    final p = preview(
      status: InvitationStatus.pending,
      expiresIn: const Duration(seconds: -1),
    );
    expect(p.isExpired, isTrue);
    expect(p.isOpen, isFalse);
  });

  test('a non-pending invite is not open', () {
    final p = preview(
      status: InvitationStatus.accepted,
      expiresIn: const Duration(days: 3),
    );
    expect(p.isOpen, isFalse);
  });

  test('invitation deep link embeds the code', () {
    final invitation = Invitation(
      id: 'i1',
      tripId: 't1',
      code: 'XYZ',
      status: InvitationStatus.pending,
      expiresAt: DateTime(2026, 7, 8),
    );
    expect(invitation.deepLink, 'https://tripmate.app/invite/XYZ');
  });
}
