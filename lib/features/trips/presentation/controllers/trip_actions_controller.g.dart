// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_actions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tripActionsControllerHash() =>
    r'e4b05ef2e38e7ca280e96c14b9ca23a75527ab60';

/// Archive / unarchive / delete actions for a trip (UI/UX §3.5/§3.7/§3.17).
/// Returns the [Failure] on error (null on success) so callers can show a
/// targeted message while the list updates reactively.
///
/// Copied from [TripActionsController].
@ProviderFor(TripActionsController)
final tripActionsControllerProvider = AutoDisposeNotifierProvider<
    TripActionsController, AsyncValue<void>>.internal(
  TripActionsController.new,
  name: r'tripActionsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tripActionsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TripActionsController = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
