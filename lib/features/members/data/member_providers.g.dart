// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$memberDaoHash() => r'ec6914602b27c83e250b9acc42a0273e2e9a0cb0';

/// See also [memberDao].
@ProviderFor(memberDao)
final memberDaoProvider = Provider<MemberDao>.internal(
  memberDao,
  name: r'memberDaoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$memberDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MemberDaoRef = ProviderRef<MemberDao>;
String _$memberRemoteDataSourceHash() =>
    r'202168fe86e685f5c25c328a7793e85149ad95f1';

/// See also [memberRemoteDataSource].
@ProviderFor(memberRemoteDataSource)
final memberRemoteDataSourceProvider =
    Provider<MemberRemoteDataSource>.internal(
  memberRemoteDataSource,
  name: r'memberRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$memberRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MemberRemoteDataSourceRef = ProviderRef<MemberRemoteDataSource>;
String _$inviteRemoteDataSourceHash() =>
    r'086a8fd9d03812daf3b78eebf3fc09637c4aab6e';

/// See also [inviteRemoteDataSource].
@ProviderFor(inviteRemoteDataSource)
final inviteRemoteDataSourceProvider =
    Provider<InviteRemoteDataSource>.internal(
  inviteRemoteDataSource,
  name: r'inviteRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inviteRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InviteRemoteDataSourceRef = ProviderRef<InviteRemoteDataSource>;
String _$memberRepositoryHash() => r'4d1ca871d36fecc16cba80e958dac50f8b44f251';

/// See also [memberRepository].
@ProviderFor(memberRepository)
final memberRepositoryProvider = Provider<MemberRepository>.internal(
  memberRepository,
  name: r'memberRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$memberRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MemberRepositoryRef = ProviderRef<MemberRepository>;
String _$tripMembersHash() => r'0c25429c1a7bcfe7d8eecaef745ac09690ce5658';

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

/// Roster stream for a trip (UI/UX §3.12).
///
/// Copied from [tripMembers].
@ProviderFor(tripMembers)
const tripMembersProvider = TripMembersFamily();

/// Roster stream for a trip (UI/UX §3.12).
///
/// Copied from [tripMembers].
class TripMembersFamily extends Family<AsyncValue<List<Member>>> {
  /// Roster stream for a trip (UI/UX §3.12).
  ///
  /// Copied from [tripMembers].
  const TripMembersFamily();

  /// Roster stream for a trip (UI/UX §3.12).
  ///
  /// Copied from [tripMembers].
  TripMembersProvider call(
    String tripId,
  ) {
    return TripMembersProvider(
      tripId,
    );
  }

  @override
  TripMembersProvider getProviderOverride(
    covariant TripMembersProvider provider,
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
  String? get name => r'tripMembersProvider';
}

/// Roster stream for a trip (UI/UX §3.12).
///
/// Copied from [tripMembers].
class TripMembersProvider extends AutoDisposeStreamProvider<List<Member>> {
  /// Roster stream for a trip (UI/UX §3.12).
  ///
  /// Copied from [tripMembers].
  TripMembersProvider(
    String tripId,
  ) : this._internal(
          (ref) => tripMembers(
            ref as TripMembersRef,
            tripId,
          ),
          from: tripMembersProvider,
          name: r'tripMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tripMembersHash,
          dependencies: TripMembersFamily._dependencies,
          allTransitiveDependencies:
              TripMembersFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  TripMembersProvider._internal(
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
    Stream<List<Member>> Function(TripMembersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TripMembersProvider._internal(
        (ref) => create(ref as TripMembersRef),
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
  AutoDisposeStreamProviderElement<List<Member>> createElement() {
    return _TripMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TripMembersProvider && other.tripId == tripId;
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
mixin TripMembersRef on AutoDisposeStreamProviderRef<List<Member>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _TripMembersProviderElement
    extends AutoDisposeStreamProviderElement<List<Member>> with TripMembersRef {
  _TripMembersProviderElement(super.provider);

  @override
  String get tripId => (origin as TripMembersProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
