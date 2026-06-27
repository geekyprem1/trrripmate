// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_actions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$memberActionsControllerHash() =>
    r'b7cf11b728e9db2c2405f3e361297e9ea6c4e581';

/// Member management actions (UI/UX §3.12, PRD REQ-MEM-03). Returns the
/// [Failure] on error (null on success) so the screen can show a targeted
/// message (e.g. dues-blocked removal) while the roster updates reactively.
///
/// Copied from [MemberActionsController].
@ProviderFor(MemberActionsController)
final memberActionsControllerProvider =
    AutoDisposeAsyncNotifierProvider<MemberActionsController, void>.internal(
  MemberActionsController.new,
  name: r'memberActionsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$memberActionsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MemberActionsController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
