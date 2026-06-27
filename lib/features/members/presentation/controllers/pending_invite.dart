import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pending_invite.g.dart';

/// Holds an invite code captured from a deep link while the user is signed out,
/// so the router can resume the Join flow after authentication (UI/UX §3.13).
@Riverpod(keepAlive: true)
class PendingInvite extends _$PendingInvite {
  @override
  String? build() => null;

  // Notifier state mutation, not a simple property setter.
  // ignore: use_setters_to_change_properties
  void set(String code) => state = code;

  void clear() => state = null;
}
