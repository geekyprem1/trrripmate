// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_actions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settlementActionsControllerHash() =>
    r'57e513d7a4d4e05ea90b9b13403a0dbabfce8693';

/// Mark-settlement-paid action (UI/UX §3.14). Returns the [Failure] on error
/// (null on success); the settlement view updates reactively. While the build
/// is loading the row's action is disabled, preventing double-marking.
///
/// Copied from [SettlementActionsController].
@ProviderFor(SettlementActionsController)
final settlementActionsControllerProvider = AutoDisposeAsyncNotifierProvider<
    SettlementActionsController, void>.internal(
  SettlementActionsController.new,
  name: r'settlementActionsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settlementActionsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettlementActionsController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
