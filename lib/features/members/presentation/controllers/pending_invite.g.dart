// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_invite.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingInviteHash() => r'fa64e8ae926aaefd7e5d6b06fa78adde3e79fc88';

/// Holds an invite code captured from a deep link while the user is signed out,
/// so the router can resume the Join flow after authentication (UI/UX §3.13).
///
/// Copied from [PendingInvite].
@ProviderFor(PendingInvite)
final pendingInviteProvider = NotifierProvider<PendingInvite, String?>.internal(
  PendingInvite.new,
  name: r'pendingInviteProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingInviteHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PendingInvite = Notifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
