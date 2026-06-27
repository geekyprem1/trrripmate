// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paywall_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paywallControllerHash() => r'75e4a92f1e81c501346aa86cdc116875aa082fe3';

/// Drives the Paywall screen's purchase and restore flows (UI/UX §3.19).
/// Uses [AsyncNotifier] so the UI can handle all three states.
///
/// Copied from [PaywallController].
@ProviderFor(PaywallController)
final paywallControllerProvider =
    AutoDisposeAsyncNotifierProvider<PaywallController, void>.internal(
  PaywallController.new,
  name: r'paywallControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paywallControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaywallController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
