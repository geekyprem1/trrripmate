// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$invitePreviewHash() => r'dd758cd17526b2c0c3fa3f75a5f623684d2ca6b3';

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

/// Loads a read-only preview of an invitation (UI/UX §3.13). The error arm
/// carries the typed `Failure` for display.
///
/// Copied from [invitePreview].
@ProviderFor(invitePreview)
const invitePreviewProvider = InvitePreviewFamily();

/// Loads a read-only preview of an invitation (UI/UX §3.13). The error arm
/// carries the typed `Failure` for display.
///
/// Copied from [invitePreview].
class InvitePreviewFamily extends Family<AsyncValue<InvitePreview>> {
  /// Loads a read-only preview of an invitation (UI/UX §3.13). The error arm
  /// carries the typed `Failure` for display.
  ///
  /// Copied from [invitePreview].
  const InvitePreviewFamily();

  /// Loads a read-only preview of an invitation (UI/UX §3.13). The error arm
  /// carries the typed `Failure` for display.
  ///
  /// Copied from [invitePreview].
  InvitePreviewProvider call(
    String code,
  ) {
    return InvitePreviewProvider(
      code,
    );
  }

  @override
  InvitePreviewProvider getProviderOverride(
    covariant InvitePreviewProvider provider,
  ) {
    return call(
      provider.code,
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
  String? get name => r'invitePreviewProvider';
}

/// Loads a read-only preview of an invitation (UI/UX §3.13). The error arm
/// carries the typed `Failure` for display.
///
/// Copied from [invitePreview].
class InvitePreviewProvider extends AutoDisposeFutureProvider<InvitePreview> {
  /// Loads a read-only preview of an invitation (UI/UX §3.13). The error arm
  /// carries the typed `Failure` for display.
  ///
  /// Copied from [invitePreview].
  InvitePreviewProvider(
    String code,
  ) : this._internal(
          (ref) => invitePreview(
            ref as InvitePreviewRef,
            code,
          ),
          from: invitePreviewProvider,
          name: r'invitePreviewProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$invitePreviewHash,
          dependencies: InvitePreviewFamily._dependencies,
          allTransitiveDependencies:
              InvitePreviewFamily._allTransitiveDependencies,
          code: code,
        );

  InvitePreviewProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.code,
  }) : super.internal();

  final String code;

  @override
  Override overrideWith(
    FutureOr<InvitePreview> Function(InvitePreviewRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InvitePreviewProvider._internal(
        (ref) => create(ref as InvitePreviewRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        code: code,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<InvitePreview> createElement() {
    return _InvitePreviewProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InvitePreviewProvider && other.code == code;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, code.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin InvitePreviewRef on AutoDisposeFutureProviderRef<InvitePreview> {
  /// The parameter `code` of this provider.
  String get code;
}

class _InvitePreviewProviderElement
    extends AutoDisposeFutureProviderElement<InvitePreview>
    with InvitePreviewRef {
  _InvitePreviewProviderElement(super.provider);

  @override
  String get code => (origin as InvitePreviewProvider).code;
}

String _$joinControllerHash() => r'f1f205fc0f341966ecc9a6da768df4a149a80344';

/// Accept / reject actions for the Join screen (PRD REQ-MEM-02).
///
/// Copied from [JoinController].
@ProviderFor(JoinController)
final joinControllerProvider =
    AutoDisposeNotifierProvider<JoinController, AsyncValue<void>>.internal(
  JoinController.new,
  name: r'joinControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$joinControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$JoinController = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
