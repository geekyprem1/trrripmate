// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_plan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tripPlanDaoHash() => r'39827f2ff67743466b50f21586501131adb4e316';

/// See also [tripPlanDao].
@ProviderFor(tripPlanDao)
final tripPlanDaoProvider = Provider<TripPlanDao>.internal(
  tripPlanDao,
  name: r'tripPlanDaoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tripPlanDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TripPlanDaoRef = ProviderRef<TripPlanDao>;
String _$tripPlanItemsHash() => r'265070b5acd75615977a2d1f80e4f296ad2cd7e0';

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

/// See also [tripPlanItems].
@ProviderFor(tripPlanItems)
const tripPlanItemsProvider = TripPlanItemsFamily();

/// See also [tripPlanItems].
class TripPlanItemsFamily extends Family<AsyncValue<List<TripPlanItemRow>>> {
  /// See also [tripPlanItems].
  const TripPlanItemsFamily();

  /// See also [tripPlanItems].
  TripPlanItemsProvider call(
    String tripId,
  ) {
    return TripPlanItemsProvider(
      tripId,
    );
  }

  @override
  TripPlanItemsProvider getProviderOverride(
    covariant TripPlanItemsProvider provider,
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
  String? get name => r'tripPlanItemsProvider';
}

/// See also [tripPlanItems].
class TripPlanItemsProvider
    extends AutoDisposeStreamProvider<List<TripPlanItemRow>> {
  /// See also [tripPlanItems].
  TripPlanItemsProvider(
    String tripId,
  ) : this._internal(
          (ref) => tripPlanItems(
            ref as TripPlanItemsRef,
            tripId,
          ),
          from: tripPlanItemsProvider,
          name: r'tripPlanItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tripPlanItemsHash,
          dependencies: TripPlanItemsFamily._dependencies,
          allTransitiveDependencies:
              TripPlanItemsFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  TripPlanItemsProvider._internal(
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
    Stream<List<TripPlanItemRow>> Function(TripPlanItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TripPlanItemsProvider._internal(
        (ref) => create(ref as TripPlanItemsRef),
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
  AutoDisposeStreamProviderElement<List<TripPlanItemRow>> createElement() {
    return _TripPlanItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TripPlanItemsProvider && other.tripId == tripId;
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
mixin TripPlanItemsRef on AutoDisposeStreamProviderRef<List<TripPlanItemRow>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _TripPlanItemsProviderElement
    extends AutoDisposeStreamProviderElement<List<TripPlanItemRow>>
    with TripPlanItemsRef {
  _TripPlanItemsProviderElement(super.provider);

  @override
  String get tripId => (origin as TripPlanItemsProvider).tripId;
}

String _$tripPlanServiceHash() => r'e086cb114bb48b3033b7fc2a094195339b8a15b0';

/// See also [tripPlanService].
@ProviderFor(tripPlanService)
final tripPlanServiceProvider = Provider<TripPlanService>.internal(
  tripPlanService,
  name: r'tripPlanServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tripPlanServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TripPlanServiceRef = ProviderRef<TripPlanService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
