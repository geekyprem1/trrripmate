// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncQueueDaoHash() => r'622ffb62ff1eab2507120d97a53a4a91be95dc69';

/// See also [syncQueueDao].
@ProviderFor(syncQueueDao)
final syncQueueDaoProvider = Provider<SyncQueueDao>.internal(
  syncQueueDao,
  name: r'syncQueueDaoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncQueueDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncQueueDaoRef = ProviderRef<SyncQueueDao>;
String _$connectivityServiceHash() =>
    r'95e1b48f96e075c047a46e92aa33a19a18e68e05';

/// See also [connectivityService].
@ProviderFor(connectivityService)
final connectivityServiceProvider = Provider<ConnectivityService>.internal(
  connectivityService,
  name: r'connectivityServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectivityServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConnectivityServiceRef = ProviderRef<ConnectivityService>;
String _$syncHandlersHash() => r'50a7a0abfa6ff34e1134c9752662009da9c8c87e';

/// Extension point for feature sync handlers (Architecture §6). Core declares
/// it empty; the composition root (bootstrap) overrides it to register each
/// feature's handler — keeping `core/` independent of `features/`.
///
/// Copied from [syncHandlers].
@ProviderFor(syncHandlers)
final syncHandlersProvider = Provider<List<SyncHandler>>.internal(
  syncHandlers,
  name: r'syncHandlersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncHandlersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncHandlersRef = ProviderRef<List<SyncHandler>>;
String _$syncEngineHash() => r'c7a5e6c75b16cde57cc377e8f4e1508228f1c997';

/// The single sync engine instance, wired with the registered handlers and a
/// connectivity-driven retry trigger.
///
/// Copied from [syncEngine].
@ProviderFor(syncEngine)
final syncEngineProvider = Provider<SyncEngine>.internal(
  syncEngine,
  name: r'syncEngineProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncEngineHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncEngineRef = ProviderRef<SyncEngine>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
