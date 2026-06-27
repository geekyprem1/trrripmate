// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$forecastDaoHash() => r'5ef3eba15b50fd59031b1349ee8742ab497d31a6';

/// See also [forecastDao].
@ProviderFor(forecastDao)
final forecastDaoProvider = Provider<ForecastDao>.internal(
  forecastDao,
  name: r'forecastDaoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$forecastDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ForecastDaoRef = ProviderRef<ForecastDao>;
String _$forecastRepositoryHash() =>
    r'a72eb684a052f2386857f1e9f22ecc74896e1e05';

/// See also [forecastRepository].
@ProviderFor(forecastRepository)
final forecastRepositoryProvider = Provider<ForecastRepository>.internal(
  forecastRepository,
  name: r'forecastRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$forecastRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ForecastRepositoryRef = ProviderRef<ForecastRepository>;
String _$forecastItemsHash() => r'3d964b7a1af8d396162864df1a7b8893bde9bf68';

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

/// See also [forecastItems].
@ProviderFor(forecastItems)
const forecastItemsProvider = ForecastItemsFamily();

/// See also [forecastItems].
class ForecastItemsFamily extends Family<AsyncValue<List<ForecastItem>>> {
  /// See also [forecastItems].
  const ForecastItemsFamily();

  /// See also [forecastItems].
  ForecastItemsProvider call(
    String tripId,
  ) {
    return ForecastItemsProvider(
      tripId,
    );
  }

  @override
  ForecastItemsProvider getProviderOverride(
    covariant ForecastItemsProvider provider,
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
  String? get name => r'forecastItemsProvider';
}

/// See also [forecastItems].
class ForecastItemsProvider
    extends AutoDisposeStreamProvider<List<ForecastItem>> {
  /// See also [forecastItems].
  ForecastItemsProvider(
    String tripId,
  ) : this._internal(
          (ref) => forecastItems(
            ref as ForecastItemsRef,
            tripId,
          ),
          from: forecastItemsProvider,
          name: r'forecastItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$forecastItemsHash,
          dependencies: ForecastItemsFamily._dependencies,
          allTransitiveDependencies:
              ForecastItemsFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  ForecastItemsProvider._internal(
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
    Stream<List<ForecastItem>> Function(ForecastItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ForecastItemsProvider._internal(
        (ref) => create(ref as ForecastItemsRef),
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
  AutoDisposeStreamProviderElement<List<ForecastItem>> createElement() {
    return _ForecastItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ForecastItemsProvider && other.tripId == tripId;
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
mixin ForecastItemsRef on AutoDisposeStreamProviderRef<List<ForecastItem>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _ForecastItemsProviderElement
    extends AutoDisposeStreamProviderElement<List<ForecastItem>>
    with ForecastItemsRef {
  _ForecastItemsProviderElement(super.provider);

  @override
  String get tripId => (origin as ForecastItemsProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
