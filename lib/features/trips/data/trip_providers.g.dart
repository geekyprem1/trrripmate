// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tripDaoHash() => r'e10042058506cc1cb99c764976eb1cb568c95e86';

/// See also [tripDao].
@ProviderFor(tripDao)
final tripDaoProvider = Provider<TripDao>.internal(
  tripDao,
  name: r'tripDaoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tripDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TripDaoRef = ProviderRef<TripDao>;
String _$tripRemoteDataSourceHash() =>
    r'6e39898c27c2d596c8c04ee63840e7f7fcf4032b';

/// See also [tripRemoteDataSource].
@ProviderFor(tripRemoteDataSource)
final tripRemoteDataSourceProvider = Provider<TripRemoteDataSource>.internal(
  tripRemoteDataSource,
  name: r'tripRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tripRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TripRemoteDataSourceRef = ProviderRef<TripRemoteDataSource>;
String _$tripSyncHandlerHash() => r'112ff459bff6a7c54667a46de754f352ad041fc3';

/// Sync handler for trips, registered with the engine via [syncHandlersProvider]
/// override in the composition root (Architecture §6).
///
/// Copied from [tripSyncHandler].
@ProviderFor(tripSyncHandler)
final tripSyncHandlerProvider = Provider<TripSyncHandler>.internal(
  tripSyncHandler,
  name: r'tripSyncHandlerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tripSyncHandlerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TripSyncHandlerRef = ProviderRef<TripSyncHandler>;
String _$tripRepositoryHash() => r'c828ed388e140abb7cd65c2da52e8902d79537ea';

/// See also [tripRepository].
@ProviderFor(tripRepository)
final tripRepositoryProvider = Provider<TripRepository>.internal(
  tripRepository,
  name: r'tripRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tripRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TripRepositoryRef = ProviderRef<TripRepository>;
String _$activeTripsHash() => r'5f17154b0b089fd355eecc5c456c37d5ec50d226';

/// Active trips stream for the Home screen (UI/UX §3.5).
///
/// Copied from [activeTrips].
@ProviderFor(activeTrips)
final activeTripsProvider = AutoDisposeStreamProvider<List<Trip>>.internal(
  activeTrips,
  name: r'activeTripsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeTripsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveTripsRef = AutoDisposeStreamProviderRef<List<Trip>>;
String _$archivedTripsHash() => r'19d02c2555717d193e3c4713257e675f704dffc0';

/// Archived trips stream (UI/UX §3.17).
///
/// Copied from [archivedTrips].
@ProviderFor(archivedTrips)
final archivedTripsProvider = AutoDisposeStreamProvider<List<Trip>>.internal(
  archivedTrips,
  name: r'archivedTripsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$archivedTripsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ArchivedTripsRef = AutoDisposeStreamProviderRef<List<Trip>>;
String _$tripByIdHash() => r'e06d0d0d189a0978fa332d429bf99c22a8ec7a09';

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

/// Single trip stream for the Dashboard (UI/UX §3.7).
///
/// Copied from [tripById].
@ProviderFor(tripById)
const tripByIdProvider = TripByIdFamily();

/// Single trip stream for the Dashboard (UI/UX §3.7).
///
/// Copied from [tripById].
class TripByIdFamily extends Family<AsyncValue<Trip?>> {
  /// Single trip stream for the Dashboard (UI/UX §3.7).
  ///
  /// Copied from [tripById].
  const TripByIdFamily();

  /// Single trip stream for the Dashboard (UI/UX §3.7).
  ///
  /// Copied from [tripById].
  TripByIdProvider call(
    String tripId,
  ) {
    return TripByIdProvider(
      tripId,
    );
  }

  @override
  TripByIdProvider getProviderOverride(
    covariant TripByIdProvider provider,
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
  String? get name => r'tripByIdProvider';
}

/// Single trip stream for the Dashboard (UI/UX §3.7).
///
/// Copied from [tripById].
class TripByIdProvider extends AutoDisposeStreamProvider<Trip?> {
  /// Single trip stream for the Dashboard (UI/UX §3.7).
  ///
  /// Copied from [tripById].
  TripByIdProvider(
    String tripId,
  ) : this._internal(
          (ref) => tripById(
            ref as TripByIdRef,
            tripId,
          ),
          from: tripByIdProvider,
          name: r'tripByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tripByIdHash,
          dependencies: TripByIdFamily._dependencies,
          allTransitiveDependencies: TripByIdFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  TripByIdProvider._internal(
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
    Stream<Trip?> Function(TripByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TripByIdProvider._internal(
        (ref) => create(ref as TripByIdRef),
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
  AutoDisposeStreamProviderElement<Trip?> createElement() {
    return _TripByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TripByIdProvider && other.tripId == tripId;
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
mixin TripByIdRef on AutoDisposeStreamProviderRef<Trip?> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _TripByIdProviderElement extends AutoDisposeStreamProviderElement<Trip?>
    with TripByIdRef {
  _TripByIdProviderElement(super.provider);

  @override
  String get tripId => (origin as TripByIdProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
