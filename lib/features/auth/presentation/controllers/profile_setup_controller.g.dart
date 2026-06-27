// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_setup_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileSetupControllerHash() =>
    r'56ef7140f4d22de3017166819d276db01384d59f';

/// Drives the Profile Setup / onboarding screen (UI/UX §3.4). On success it
/// invalidates [profileStatusProvider] so the router advances to Home.
///
/// Copied from [ProfileSetupController].
@ProviderFor(ProfileSetupController)
final profileSetupControllerProvider = AutoDisposeNotifierProvider<
    ProfileSetupController, AsyncValue<void>>.internal(
  ProfileSetupController.new,
  name: r'profileSetupControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileSetupControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileSetupController = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
