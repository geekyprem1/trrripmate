// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_actions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expenseActionsControllerHash() =>
    r'f3e965b27bd72f232d59fdec0e5a65f14c420738';

/// Delete / approve / reject actions (UI/UX §3.10/§3.11). Returns the [Failure]
/// on error (null on success) while the list/detail updates reactively.
///
/// Copied from [ExpenseActionsController].
@ProviderFor(ExpenseActionsController)
final expenseActionsControllerProvider =
    AutoDisposeAsyncNotifierProvider<ExpenseActionsController, void>.internal(
  ExpenseActionsController.new,
  name: r'expenseActionsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseActionsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExpenseActionsController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
