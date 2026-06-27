// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_filter_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportFilterControllerHash() =>
    r'adabc309349b3c1330549b709c12c062b92449ba';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ReportFilterController
    extends BuildlessAutoDisposeNotifier<ReportFilter> {
  late final String tripId;

  ReportFilter build(
    String tripId,
  );
}

/// Holds the current [ReportFilter] for a trip's Reports screen (UI/UX §3.15).
/// Transient screen state, scoped per trip and auto-disposed.
///
/// Copied from [ReportFilterController].
@ProviderFor(ReportFilterController)
const reportFilterControllerProvider = ReportFilterControllerFamily();

/// Holds the current [ReportFilter] for a trip's Reports screen (UI/UX §3.15).
/// Transient screen state, scoped per trip and auto-disposed.
///
/// Copied from [ReportFilterController].
class ReportFilterControllerFamily extends Family<ReportFilter> {
  /// Holds the current [ReportFilter] for a trip's Reports screen (UI/UX §3.15).
  /// Transient screen state, scoped per trip and auto-disposed.
  ///
  /// Copied from [ReportFilterController].
  const ReportFilterControllerFamily();

  /// Holds the current [ReportFilter] for a trip's Reports screen (UI/UX §3.15).
  /// Transient screen state, scoped per trip and auto-disposed.
  ///
  /// Copied from [ReportFilterController].
  ReportFilterControllerProvider call(
    String tripId,
  ) {
    return ReportFilterControllerProvider(
      tripId,
    );
  }

  @override
  ReportFilterControllerProvider getProviderOverride(
    covariant ReportFilterControllerProvider provider,
  ) {
    return call(
      provider.tripId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'reportFilterControllerProvider';
}

/// Holds the current [ReportFilter] for a trip's Reports screen (UI/UX §3.15).
/// Transient screen state, scoped per trip and auto-disposed.
///
/// Copied from [ReportFilterController].
class ReportFilterControllerProvider extends AutoDisposeNotifierProviderImpl<
    ReportFilterController, ReportFilter> {
  /// Holds the current [ReportFilter] for a trip's Reports screen (UI/UX §3.15).
  /// Transient screen state, scoped per trip and auto-disposed.
  ///
  /// Copied from [ReportFilterController].
  ReportFilterControllerProvider(
    String tripId,
  ) : this._internal(
          () => ReportFilterController()..tripId = tripId,
          from: reportFilterControllerProvider,
          name: r'reportFilterControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reportFilterControllerHash,
          dependencies: ReportFilterControllerFamily._dependencies,
          allTransitiveDependencies:
              ReportFilterControllerFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  ReportFilterControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tripId,
  }) : super.internal();

  final String tripId;

  @override
  ReportFilter runNotifierBuild(
    covariant ReportFilterController notifier,
  ) {
    return notifier.build(
      tripId,
    );
  }

  @override
  Override overrideWith(ReportFilterController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ReportFilterControllerProvider._internal(
        () => create()..tripId = tripId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tripId: tripId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ReportFilterController, ReportFilter>
      createElement() {
    return _ReportFilterControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportFilterControllerProvider && other.tripId == tripId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tripId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReportFilterControllerRef
    on AutoDisposeNotifierProviderRef<ReportFilter> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _ReportFilterControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ReportFilterController,
        ReportFilter> with ReportFilterControllerRef {
  _ReportFilterControllerProviderElement(super.provider);

  @override
  String get tripId => (origin as ReportFilterControllerProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
