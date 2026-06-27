// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$friendsDaoHash() => r'55500428fb3322e36884ea08139068d747378ee5';

/// See also [friendsDao].
@ProviderFor(friendsDao)
final friendsDaoProvider = Provider<FriendsDao>.internal(
  friendsDao,
  name: r'friendsDaoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$friendsDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FriendsDaoRef = ProviderRef<FriendsDao>;
String _$friendsRemoteDataSourceHash() =>
    r'1b18731b8dce6a1863ba6c0221970c14a153ba7f';

/// See also [friendsRemoteDataSource].
@ProviderFor(friendsRemoteDataSource)
final friendsRemoteDataSourceProvider =
    Provider<FriendsRemoteDataSource>.internal(
  friendsRemoteDataSource,
  name: r'friendsRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$friendsRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FriendsRemoteDataSourceRef = ProviderRef<FriendsRemoteDataSource>;
String _$friendsRepositoryHash() => r'1fab65e180d6ae7d7b157107389bd771a8f9f47c';

/// See also [friendsRepository].
@ProviderFor(friendsRepository)
final friendsRepositoryProvider = Provider<FriendsRepository>.internal(
  friendsRepository,
  name: r'friendsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$friendsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FriendsRepositoryRef = ProviderRef<FriendsRepository>;
String _$friendsListHash() => r'369a17f6a65b714e77015224250b41391c668c6f';

/// See also [friendsList].
@ProviderFor(friendsList)
final friendsListProvider = AutoDisposeStreamProvider<List<Friend>>.internal(
  friendsList,
  name: r'friendsListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$friendsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FriendsListRef = AutoDisposeStreamProviderRef<List<Friend>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
