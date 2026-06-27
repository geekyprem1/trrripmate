// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRemoteDataSourceHash() =>
    r'be7992e1162aefd47b5ed4b822c7b4af7f894f0a';

/// See also [authRemoteDataSource].
@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>.internal(
  authRemoteDataSource,
  name: r'authRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRemoteDataSourceRef = ProviderRef<AuthRemoteDataSource>;
String _$profileRemoteDataSourceHash() =>
    r'fe86f033c1900ef1405b732e294b37ac8f9302ec';

/// See also [profileRemoteDataSource].
@ProviderFor(profileRemoteDataSource)
final profileRemoteDataSourceProvider =
    Provider<ProfileRemoteDataSource>.internal(
  profileRemoteDataSource,
  name: r'profileRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileRemoteDataSourceRef = ProviderRef<ProfileRemoteDataSource>;
String _$authRepositoryHash() => r'5a9ef05db6cf24d5497c60dedb686360eea66089';

/// The auth repository — the only auth entry point for presentation
/// (CLAUDE.md §3/§5).
///
/// Copied from [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = ProviderRef<AuthRepository>;
String _$authStateHash() => r'97ca81ed728c8d7ba5b0f50eb8590093d8d3c5a9';

/// Reactive auth state for the router and UI (Architecture §8).
///
/// Copied from [authState].
@ProviderFor(authState)
final authStateProvider = StreamProvider<AuthUser?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = StreamProviderRef<AuthUser?>;
String _$profileStatusHash() => r'063f17329b4cd004bf679461cb4eabac4b3b1ccc';

/// Whether the signed-in user already has a profile. Drives onboarding routing
/// (PRD §3.4 / UI/UX §3.4). Recomputes whenever auth state changes.
///
/// Copied from [profileStatus].
@ProviderFor(profileStatus)
final profileStatusProvider = FutureProvider<bool>.internal(
  profileStatus,
  name: r'profileStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileStatusRef = FutureProviderRef<bool>;
String _$myProfileHash() => r'fe5810d23eb49862ce5f451e441ab64410381e7f';

/// Current user's full profile — used in Settings for QR display and
/// anywhere the display name or username is needed.
///
/// Copied from [myProfile].
@ProviderFor(myProfile)
final myProfileProvider = FutureProvider<UserProfile?>.internal(
  myProfile,
  name: r'myProfileProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyProfileRef = FutureProviderRef<UserProfile?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
