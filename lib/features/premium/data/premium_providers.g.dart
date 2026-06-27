// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$billingServiceHash() => r'da1e3345f0dff18a0d5382c7318f1c9f84cc0533';

/// The store adapter. v1.0 ships the dev fake; the production `in_app_purchase`
/// adapter overrides this in the composition root (Architecture §7).
///
/// Copied from [billingService].
@ProviderFor(billingService)
final billingServiceProvider = Provider<BillingService>.internal(
  billingService,
  name: r'billingServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$billingServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BillingServiceRef = ProviderRef<BillingService>;
String _$entitlementRemoteDataSourceHash() =>
    r'625fb04b6934ff3e0507cc40b46e66d7e733eaa2';

/// See also [entitlementRemoteDataSource].
@ProviderFor(entitlementRemoteDataSource)
final entitlementRemoteDataSourceProvider =
    Provider<EntitlementRemoteDataSource>.internal(
  entitlementRemoteDataSource,
  name: r'entitlementRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$entitlementRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EntitlementRemoteDataSourceRef
    = ProviderRef<EntitlementRemoteDataSource>;
String _$entitlementLocalSourceHash() =>
    r'78a1f621c81280cf6dd6790982fad5b5954e9953';

/// See also [entitlementLocalSource].
@ProviderFor(entitlementLocalSource)
final entitlementLocalSourceProvider =
    Provider<EntitlementLocalSource>.internal(
  entitlementLocalSource,
  name: r'entitlementLocalSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$entitlementLocalSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EntitlementLocalSourceRef = ProviderRef<EntitlementLocalSource>;
String _$premiumRepositoryHash() => r'c0376498c5383d19d9969ff546a4451ea9a832f4';

/// See also [premiumRepository].
@ProviderFor(premiumRepository)
final premiumRepositoryProvider = Provider<PremiumRepository>.internal(
  premiumRepository,
  name: r'premiumRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$premiumRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PremiumRepositoryRef = ProviderRef<PremiumRepository>;
String _$entitlementHash() => r'c828146b1edb3f36be97eeb8d35e7c54f7d6c4f5';

/// Reactive entitlement for Settings/Paywall UI.
///
/// Copied from [entitlement].
@ProviderFor(entitlement)
final entitlementProvider = AutoDisposeStreamProvider<Entitlement>.internal(
  entitlement,
  name: r'entitlementProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$entitlementHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EntitlementRef = AutoDisposeStreamProviderRef<Entitlement>;
String _$premiumPlansHash() => r'0dbf752cb94a0b8a0274b3123e5d5f2e2295a52a';

/// Store-localized plans for the paywall.
///
/// Copied from [premiumPlans].
@ProviderFor(premiumPlans)
final premiumPlansProvider =
    AutoDisposeFutureProvider<List<PremiumPlan>>.internal(
  premiumPlans,
  name: r'premiumPlansProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$premiumPlansHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PremiumPlansRef = AutoDisposeFutureProviderRef<List<PremiumPlan>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
