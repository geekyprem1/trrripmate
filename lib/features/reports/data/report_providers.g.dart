// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportRepositoryHash() => r'506cea44bb5336b1ba8f09d785d901ecefd84bcd';

/// See also [reportRepository].
@ProviderFor(reportRepository)
final reportRepositoryProvider = Provider<ReportRepository>.internal(
  reportRepository,
  name: r'reportRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reportRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReportRepositoryRef = ProviderRef<ReportRepository>;
String _$reportDataHash() => r'4c2347a26d96871ffa640c86340e4d8c35f31b53';

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

/// The aggregated report for a trip under [filter], recomputed reactively as
/// approved expenses or members change (REQ-REP-01 realtime). Composes other
/// features' public providers (the accepted cross-feature API).
///
/// Copied from [reportData].
@ProviderFor(reportData)
const reportDataProvider = ReportDataFamily();

/// The aggregated report for a trip under [filter], recomputed reactively as
/// approved expenses or members change (REQ-REP-01 realtime). Composes other
/// features' public providers (the accepted cross-feature API).
///
/// Copied from [reportData].
class ReportDataFamily extends Family<ReportData> {
  /// The aggregated report for a trip under [filter], recomputed reactively as
  /// approved expenses or members change (REQ-REP-01 realtime). Composes other
  /// features' public providers (the accepted cross-feature API).
  ///
  /// Copied from [reportData].
  const ReportDataFamily();

  /// The aggregated report for a trip under [filter], recomputed reactively as
  /// approved expenses or members change (REQ-REP-01 realtime). Composes other
  /// features' public providers (the accepted cross-feature API).
  ///
  /// Copied from [reportData].
  ReportDataProvider call(
    String tripId,
    ReportFilter filter,
  ) {
    return ReportDataProvider(
      tripId,
      filter,
    );
  }

  @override
  ReportDataProvider getProviderOverride(
    covariant ReportDataProvider provider,
  ) {
    return call(
      provider.tripId,
      provider.filter,
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
  String? get name => r'reportDataProvider';
}

/// The aggregated report for a trip under [filter], recomputed reactively as
/// approved expenses or members change (REQ-REP-01 realtime). Composes other
/// features' public providers (the accepted cross-feature API).
///
/// Copied from [reportData].
class ReportDataProvider extends AutoDisposeProvider<ReportData> {
  /// The aggregated report for a trip under [filter], recomputed reactively as
  /// approved expenses or members change (REQ-REP-01 realtime). Composes other
  /// features' public providers (the accepted cross-feature API).
  ///
  /// Copied from [reportData].
  ReportDataProvider(
    String tripId,
    ReportFilter filter,
  ) : this._internal(
          (ref) => reportData(
            ref as ReportDataRef,
            tripId,
            filter,
          ),
          from: reportDataProvider,
          name: r'reportDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reportDataHash,
          dependencies: ReportDataFamily._dependencies,
          allTransitiveDependencies:
              ReportDataFamily._allTransitiveDependencies,
          tripId: tripId,
          filter: filter,
        );

  ReportDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tripId,
    required this.filter,
  }) : super.internal();

  final String tripId;
  final ReportFilter filter;

  @override
  Override overrideWith(
    ReportData Function(ReportDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReportDataProvider._internal(
        (ref) => create(ref as ReportDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tripId: tripId,
        filter: filter,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<ReportData> createElement() {
    return _ReportDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportDataProvider &&
        other.tripId == tripId &&
        other.filter == filter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tripId.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReportDataRef on AutoDisposeProviderRef<ReportData> {
  /// The parameter `tripId` of this provider.
  String get tripId;

  /// The parameter `filter` of this provider.
  ReportFilter get filter;
}

class _ReportDataProviderElement extends AutoDisposeProviderElement<ReportData>
    with ReportDataRef {
  _ReportDataProviderElement(super.provider);

  @override
  String get tripId => (origin as ReportDataProvider).tripId;
  @override
  ReportFilter get filter => (origin as ReportDataProvider).filter;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
