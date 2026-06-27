// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settlementDaoHash() => r'e9b1000308fad2cff69085795ffd51d0176cb814';

/// See also [settlementDao].
@ProviderFor(settlementDao)
final settlementDaoProvider = Provider<SettlementDao>.internal(
  settlementDao,
  name: r'settlementDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settlementDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettlementDaoRef = ProviderRef<SettlementDao>;
String _$settlementRemoteDataSourceHash() =>
    r'2b5447f55ba1623db9d2da89184aed660c1d025b';

/// See also [settlementRemoteDataSource].
@ProviderFor(settlementRemoteDataSource)
final settlementRemoteDataSourceProvider =
    Provider<SettlementRemoteDataSource>.internal(
  settlementRemoteDataSource,
  name: r'settlementRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settlementRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettlementRemoteDataSourceRef = ProviderRef<SettlementRemoteDataSource>;
String _$settlementSyncHandlerHash() =>
    r'1085f28c30e9010c833ada80dd9182cab8769f8d';

/// Settlement sync handler, registered with the engine via [syncHandlersProvider]
/// override in the composition root (Architecture §6).
///
/// Copied from [settlementSyncHandler].
@ProviderFor(settlementSyncHandler)
final settlementSyncHandlerProvider = Provider<SettlementSyncHandler>.internal(
  settlementSyncHandler,
  name: r'settlementSyncHandlerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settlementSyncHandlerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettlementSyncHandlerRef = ProviderRef<SettlementSyncHandler>;
String _$settlementRepositoryHash() =>
    r'f7e6664907183bfdb1406004a3236084f743499e';

/// See also [settlementRepository].
@ProviderFor(settlementRepository)
final settlementRepositoryProvider = Provider<SettlementRepository>.internal(
  settlementRepository,
  name: r'settlementRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settlementRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettlementRepositoryRef = ProviderRef<SettlementRepository>;
String _$completedSettlementsHash() =>
    r'29fdce5d4142c0a52d1c7297c850754d042232dc';

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

/// Completed payments (the settlement ledger) for a trip.
///
/// Copied from [completedSettlements].
@ProviderFor(completedSettlements)
const completedSettlementsProvider = CompletedSettlementsFamily();

/// Completed payments (the settlement ledger) for a trip.
///
/// Copied from [completedSettlements].
class CompletedSettlementsFamily extends Family<AsyncValue<List<Settlement>>> {
  /// Completed payments (the settlement ledger) for a trip.
  ///
  /// Copied from [completedSettlements].
  const CompletedSettlementsFamily();

  /// Completed payments (the settlement ledger) for a trip.
  ///
  /// Copied from [completedSettlements].
  CompletedSettlementsProvider call(
    String tripId,
  ) {
    return CompletedSettlementsProvider(
      tripId,
    );
  }

  @override
  CompletedSettlementsProvider getProviderOverride(
    covariant CompletedSettlementsProvider provider,
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
  String? get name => r'completedSettlementsProvider';
}

/// Completed payments (the settlement ledger) for a trip.
///
/// Copied from [completedSettlements].
class CompletedSettlementsProvider
    extends AutoDisposeStreamProvider<List<Settlement>> {
  /// Completed payments (the settlement ledger) for a trip.
  ///
  /// Copied from [completedSettlements].
  CompletedSettlementsProvider(
    String tripId,
  ) : this._internal(
          (ref) => completedSettlements(
            ref as CompletedSettlementsRef,
            tripId,
          ),
          from: completedSettlementsProvider,
          name: r'completedSettlementsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$completedSettlementsHash,
          dependencies: CompletedSettlementsFamily._dependencies,
          allTransitiveDependencies:
              CompletedSettlementsFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  CompletedSettlementsProvider._internal(
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
  Override overrideWith(
    Stream<List<Settlement>> Function(CompletedSettlementsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CompletedSettlementsProvider._internal(
        (ref) => create(ref as CompletedSettlementsRef),
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
  AutoDisposeStreamProviderElement<List<Settlement>> createElement() {
    return _CompletedSettlementsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompletedSettlementsProvider && other.tripId == tripId;
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
mixin CompletedSettlementsRef
    on AutoDisposeStreamProviderRef<List<Settlement>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _CompletedSettlementsProviderElement
    extends AutoDisposeStreamProviderElement<List<Settlement>>
    with CompletedSettlementsRef {
  _CompletedSettlementsProviderElement(super.provider);

  @override
  String get tripId => (origin as CompletedSettlementsProvider).tripId;
}

String _$tripSettlementSummaryHash() =>
    r'6e11859b7594831c9e3e1ccdd7350e07b7cdcc4e';

/// The reactive settlement picture (balances + outstanding transactions),
/// recomputed whenever approved expenses, members, or completed payments change
/// (PRD REQ-SET-01 — recompute on changes; auto-reopen). Composes other
/// features' public providers (the accepted cross-feature API).
///
/// Copied from [tripSettlementSummary].
@ProviderFor(tripSettlementSummary)
const tripSettlementSummaryProvider = TripSettlementSummaryFamily();

/// The reactive settlement picture (balances + outstanding transactions),
/// recomputed whenever approved expenses, members, or completed payments change
/// (PRD REQ-SET-01 — recompute on changes; auto-reopen). Composes other
/// features' public providers (the accepted cross-feature API).
///
/// Copied from [tripSettlementSummary].
class TripSettlementSummaryFamily extends Family<SettlementSummary> {
  /// The reactive settlement picture (balances + outstanding transactions),
  /// recomputed whenever approved expenses, members, or completed payments change
  /// (PRD REQ-SET-01 — recompute on changes; auto-reopen). Composes other
  /// features' public providers (the accepted cross-feature API).
  ///
  /// Copied from [tripSettlementSummary].
  const TripSettlementSummaryFamily();

  /// The reactive settlement picture (balances + outstanding transactions),
  /// recomputed whenever approved expenses, members, or completed payments change
  /// (PRD REQ-SET-01 — recompute on changes; auto-reopen). Composes other
  /// features' public providers (the accepted cross-feature API).
  ///
  /// Copied from [tripSettlementSummary].
  TripSettlementSummaryProvider call(
    String tripId,
  ) {
    return TripSettlementSummaryProvider(
      tripId,
    );
  }

  @override
  TripSettlementSummaryProvider getProviderOverride(
    covariant TripSettlementSummaryProvider provider,
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
  String? get name => r'tripSettlementSummaryProvider';
}

/// The reactive settlement picture (balances + outstanding transactions),
/// recomputed whenever approved expenses, members, or completed payments change
/// (PRD REQ-SET-01 — recompute on changes; auto-reopen). Composes other
/// features' public providers (the accepted cross-feature API).
///
/// Copied from [tripSettlementSummary].
class TripSettlementSummaryProvider
    extends AutoDisposeProvider<SettlementSummary> {
  /// The reactive settlement picture (balances + outstanding transactions),
  /// recomputed whenever approved expenses, members, or completed payments change
  /// (PRD REQ-SET-01 — recompute on changes; auto-reopen). Composes other
  /// features' public providers (the accepted cross-feature API).
  ///
  /// Copied from [tripSettlementSummary].
  TripSettlementSummaryProvider(
    String tripId,
  ) : this._internal(
          (ref) => tripSettlementSummary(
            ref as TripSettlementSummaryRef,
            tripId,
          ),
          from: tripSettlementSummaryProvider,
          name: r'tripSettlementSummaryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tripSettlementSummaryHash,
          dependencies: TripSettlementSummaryFamily._dependencies,
          allTransitiveDependencies:
              TripSettlementSummaryFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  TripSettlementSummaryProvider._internal(
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
  Override overrideWith(
    SettlementSummary Function(TripSettlementSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TripSettlementSummaryProvider._internal(
        (ref) => create(ref as TripSettlementSummaryRef),
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
  AutoDisposeProviderElement<SettlementSummary> createElement() {
    return _TripSettlementSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TripSettlementSummaryProvider && other.tripId == tripId;
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
mixin TripSettlementSummaryRef on AutoDisposeProviderRef<SettlementSummary> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _TripSettlementSummaryProviderElement
    extends AutoDisposeProviderElement<SettlementSummary>
    with TripSettlementSummaryRef {
  _TripSettlementSummaryProviderElement(super.provider);

  @override
  String get tripId => (origin as TripSettlementSummaryProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
