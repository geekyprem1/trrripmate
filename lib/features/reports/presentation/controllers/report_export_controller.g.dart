// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_export_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportExportControllerHash() =>
    r'0d17bc2a05637127ba96acc3ebf72614d779440e';

/// Drives the "Export PDF" action (UI/UX §3.15). Exposes loading via the
/// AsyncValue (the button shows a spinner) and returns the [Failure] on error
/// (null on success) so the screen can offer retry.
///
/// Copied from [ReportExportController].
@ProviderFor(ReportExportController)
final reportExportControllerProvider =
    AutoDisposeAsyncNotifierProvider<ReportExportController, void>.internal(
  ReportExportController.new,
  name: r'reportExportControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reportExportControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReportExportController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
