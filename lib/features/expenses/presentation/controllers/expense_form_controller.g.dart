// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expenseFormControllerHash() =>
    r'40f2b49c0d36fb8775e52c7a8786bced483d4b7c';

/// Drives the Add / Edit Expense form (UI/UX §3.9). Holds the submit
/// [AsyncValue]; returns `true` so the screen can pop on success. The screen
/// disables the button while loading to debounce duplicate taps (REQ-EXP-01).
///
/// Copied from [ExpenseFormController].
@ProviderFor(ExpenseFormController)
final expenseFormControllerProvider = AutoDisposeNotifierProvider<
    ExpenseFormController, AsyncValue<void>>.internal(
  ExpenseFormController.new,
  name: r'expenseFormControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseFormControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExpenseFormController = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
