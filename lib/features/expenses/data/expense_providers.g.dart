// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expenseDaoHash() => r'3c57017cbb19afd1b2c8eefd7e5e9453acd09024';

/// See also [expenseDao].
@ProviderFor(expenseDao)
final expenseDaoProvider = Provider<ExpenseDao>.internal(
  expenseDao,
  name: r'expenseDaoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$expenseDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpenseDaoRef = ProviderRef<ExpenseDao>;
String _$expenseRemoteDataSourceHash() =>
    r'd207abcf29f1855ffeed4dd157db9d3985a599b6';

/// See also [expenseRemoteDataSource].
@ProviderFor(expenseRemoteDataSource)
final expenseRemoteDataSourceProvider =
    Provider<ExpenseRemoteDataSource>.internal(
  expenseRemoteDataSource,
  name: r'expenseRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpenseRemoteDataSourceRef = ProviderRef<ExpenseRemoteDataSource>;
String _$receiptRemoteDataSourceHash() =>
    r'4427d395881f592aede3032ec0e8f254d26d8f1a';

/// See also [receiptRemoteDataSource].
@ProviderFor(receiptRemoteDataSource)
final receiptRemoteDataSourceProvider =
    Provider<ReceiptRemoteDataSource>.internal(
  receiptRemoteDataSource,
  name: r'receiptRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$receiptRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReceiptRemoteDataSourceRef = ProviderRef<ReceiptRemoteDataSource>;
String _$receiptCaptureServiceHash() =>
    r'dcd296d2faa36485638bd012195c78af7aee5d04';

/// See also [receiptCaptureService].
@ProviderFor(receiptCaptureService)
final receiptCaptureServiceProvider = Provider<ReceiptCaptureService>.internal(
  receiptCaptureService,
  name: r'receiptCaptureServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$receiptCaptureServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReceiptCaptureServiceRef = ProviderRef<ReceiptCaptureService>;
String _$expenseSyncHandlerHash() =>
    r'ba9e85889878228b3e87aad7afeab25b353f22b4';

/// Expense sync handler, registered with the engine via [syncHandlersProvider]
/// override in the composition root (Architecture §6).
///
/// Copied from [expenseSyncHandler].
@ProviderFor(expenseSyncHandler)
final expenseSyncHandlerProvider = Provider<ExpenseSyncHandler>.internal(
  expenseSyncHandler,
  name: r'expenseSyncHandlerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseSyncHandlerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpenseSyncHandlerRef = ProviderRef<ExpenseSyncHandler>;
String _$expenseRepositoryHash() => r'5294c0f97d2ebcdc9a14ecf906a40b50d0b1dad3';

/// See also [expenseRepository].
@ProviderFor(expenseRepository)
final expenseRepositoryProvider = Provider<ExpenseRepository>.internal(
  expenseRepository,
  name: r'expenseRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpenseRepositoryRef = ProviderRef<ExpenseRepository>;
String _$tripExpensesHash() => r'9f40685833c2ca9b4d39192b00aac9f925a05f45';

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

/// All non-deleted expenses for a trip (UI/UX §3.8).
///
/// Copied from [tripExpenses].
@ProviderFor(tripExpenses)
const tripExpensesProvider = TripExpensesFamily();

/// All non-deleted expenses for a trip (UI/UX §3.8).
///
/// Copied from [tripExpenses].
class TripExpensesFamily extends Family<AsyncValue<List<Expense>>> {
  /// All non-deleted expenses for a trip (UI/UX §3.8).
  ///
  /// Copied from [tripExpenses].
  const TripExpensesFamily();

  /// All non-deleted expenses for a trip (UI/UX §3.8).
  ///
  /// Copied from [tripExpenses].
  TripExpensesProvider call(
    String tripId,
  ) {
    return TripExpensesProvider(
      tripId,
    );
  }

  @override
  TripExpensesProvider getProviderOverride(
    covariant TripExpensesProvider provider,
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
  String? get name => r'tripExpensesProvider';
}

/// All non-deleted expenses for a trip (UI/UX §3.8).
///
/// Copied from [tripExpenses].
class TripExpensesProvider extends AutoDisposeStreamProvider<List<Expense>> {
  /// All non-deleted expenses for a trip (UI/UX §3.8).
  ///
  /// Copied from [tripExpenses].
  TripExpensesProvider(
    String tripId,
  ) : this._internal(
          (ref) => tripExpenses(
            ref as TripExpensesRef,
            tripId,
          ),
          from: tripExpensesProvider,
          name: r'tripExpensesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tripExpensesHash,
          dependencies: TripExpensesFamily._dependencies,
          allTransitiveDependencies:
              TripExpensesFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  TripExpensesProvider._internal(
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
    Stream<List<Expense>> Function(TripExpensesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TripExpensesProvider._internal(
        (ref) => create(ref as TripExpensesRef),
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
  AutoDisposeStreamProviderElement<List<Expense>> createElement() {
    return _TripExpensesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TripExpensesProvider && other.tripId == tripId;
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
mixin TripExpensesRef on AutoDisposeStreamProviderRef<List<Expense>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _TripExpensesProviderElement
    extends AutoDisposeStreamProviderElement<List<Expense>>
    with TripExpensesRef {
  _TripExpensesProviderElement(super.provider);

  @override
  String get tripId => (origin as TripExpensesProvider).tripId;
}

String _$pendingExpensesHash() => r'bee003f786895f747a046e3804713cc0982549a2';

/// Pending expenses awaiting approval (Approval Queue, UI/UX §3.11).
///
/// Copied from [pendingExpenses].
@ProviderFor(pendingExpenses)
const pendingExpensesProvider = PendingExpensesFamily();

/// Pending expenses awaiting approval (Approval Queue, UI/UX §3.11).
///
/// Copied from [pendingExpenses].
class PendingExpensesFamily extends Family<AsyncValue<List<Expense>>> {
  /// Pending expenses awaiting approval (Approval Queue, UI/UX §3.11).
  ///
  /// Copied from [pendingExpenses].
  const PendingExpensesFamily();

  /// Pending expenses awaiting approval (Approval Queue, UI/UX §3.11).
  ///
  /// Copied from [pendingExpenses].
  PendingExpensesProvider call(
    String tripId,
  ) {
    return PendingExpensesProvider(
      tripId,
    );
  }

  @override
  PendingExpensesProvider getProviderOverride(
    covariant PendingExpensesProvider provider,
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
  String? get name => r'pendingExpensesProvider';
}

/// Pending expenses awaiting approval (Approval Queue, UI/UX §3.11).
///
/// Copied from [pendingExpenses].
class PendingExpensesProvider extends AutoDisposeStreamProvider<List<Expense>> {
  /// Pending expenses awaiting approval (Approval Queue, UI/UX §3.11).
  ///
  /// Copied from [pendingExpenses].
  PendingExpensesProvider(
    String tripId,
  ) : this._internal(
          (ref) => pendingExpenses(
            ref as PendingExpensesRef,
            tripId,
          ),
          from: pendingExpensesProvider,
          name: r'pendingExpensesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pendingExpensesHash,
          dependencies: PendingExpensesFamily._dependencies,
          allTransitiveDependencies:
              PendingExpensesFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  PendingExpensesProvider._internal(
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
    Stream<List<Expense>> Function(PendingExpensesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PendingExpensesProvider._internal(
        (ref) => create(ref as PendingExpensesRef),
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
  AutoDisposeStreamProviderElement<List<Expense>> createElement() {
    return _PendingExpensesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingExpensesProvider && other.tripId == tripId;
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
mixin PendingExpensesRef on AutoDisposeStreamProviderRef<List<Expense>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _PendingExpensesProviderElement
    extends AutoDisposeStreamProviderElement<List<Expense>>
    with PendingExpensesRef {
  _PendingExpensesProviderElement(super.provider);

  @override
  String get tripId => (origin as PendingExpensesProvider).tripId;
}

String _$expenseByIdHash() => r'16a4066aa30558b0c219477827f968d09a277376';

/// A single expense with its splits (Expense Detail, UI/UX §3.10).
///
/// Copied from [expenseById].
@ProviderFor(expenseById)
const expenseByIdProvider = ExpenseByIdFamily();

/// A single expense with its splits (Expense Detail, UI/UX §3.10).
///
/// Copied from [expenseById].
class ExpenseByIdFamily extends Family<AsyncValue<Expense?>> {
  /// A single expense with its splits (Expense Detail, UI/UX §3.10).
  ///
  /// Copied from [expenseById].
  const ExpenseByIdFamily();

  /// A single expense with its splits (Expense Detail, UI/UX §3.10).
  ///
  /// Copied from [expenseById].
  ExpenseByIdProvider call(
    String expenseId,
  ) {
    return ExpenseByIdProvider(
      expenseId,
    );
  }

  @override
  ExpenseByIdProvider getProviderOverride(
    covariant ExpenseByIdProvider provider,
  ) {
    return call(
      provider.expenseId,
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
  String? get name => r'expenseByIdProvider';
}

/// A single expense with its splits (Expense Detail, UI/UX §3.10).
///
/// Copied from [expenseById].
class ExpenseByIdProvider extends AutoDisposeStreamProvider<Expense?> {
  /// A single expense with its splits (Expense Detail, UI/UX §3.10).
  ///
  /// Copied from [expenseById].
  ExpenseByIdProvider(
    String expenseId,
  ) : this._internal(
          (ref) => expenseById(
            ref as ExpenseByIdRef,
            expenseId,
          ),
          from: expenseByIdProvider,
          name: r'expenseByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$expenseByIdHash,
          dependencies: ExpenseByIdFamily._dependencies,
          allTransitiveDependencies:
              ExpenseByIdFamily._allTransitiveDependencies,
          expenseId: expenseId,
        );

  ExpenseByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.expenseId,
  }) : super.internal();

  final String expenseId;

  @override
  Override overrideWith(
    Stream<Expense?> Function(ExpenseByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpenseByIdProvider._internal(
        (ref) => create(ref as ExpenseByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        expenseId: expenseId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Expense?> createElement() {
    return _ExpenseByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseByIdProvider && other.expenseId == expenseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, expenseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpenseByIdRef on AutoDisposeStreamProviderRef<Expense?> {
  /// The parameter `expenseId` of this provider.
  String get expenseId;
}

class _ExpenseByIdProviderElement
    extends AutoDisposeStreamProviderElement<Expense?> with ExpenseByIdRef {
  _ExpenseByIdProviderElement(super.provider);

  @override
  String get expenseId => (origin as ExpenseByIdProvider).expenseId;
}

String _$approvedSpentMinorHash() =>
    r'40a95a3b0abeecc354be6ae75c2d448dad06e184';

/// Reactive approved spend in minor units, feeding the budget (PRD REQ-BUD-01).
///
/// Copied from [approvedSpentMinor].
@ProviderFor(approvedSpentMinor)
const approvedSpentMinorProvider = ApprovedSpentMinorFamily();

/// Reactive approved spend in minor units, feeding the budget (PRD REQ-BUD-01).
///
/// Copied from [approvedSpentMinor].
class ApprovedSpentMinorFamily extends Family<AsyncValue<int>> {
  /// Reactive approved spend in minor units, feeding the budget (PRD REQ-BUD-01).
  ///
  /// Copied from [approvedSpentMinor].
  const ApprovedSpentMinorFamily();

  /// Reactive approved spend in minor units, feeding the budget (PRD REQ-BUD-01).
  ///
  /// Copied from [approvedSpentMinor].
  ApprovedSpentMinorProvider call(
    String tripId,
  ) {
    return ApprovedSpentMinorProvider(
      tripId,
    );
  }

  @override
  ApprovedSpentMinorProvider getProviderOverride(
    covariant ApprovedSpentMinorProvider provider,
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
  String? get name => r'approvedSpentMinorProvider';
}

/// Reactive approved spend in minor units, feeding the budget (PRD REQ-BUD-01).
///
/// Copied from [approvedSpentMinor].
class ApprovedSpentMinorProvider extends AutoDisposeStreamProvider<int> {
  /// Reactive approved spend in minor units, feeding the budget (PRD REQ-BUD-01).
  ///
  /// Copied from [approvedSpentMinor].
  ApprovedSpentMinorProvider(
    String tripId,
  ) : this._internal(
          (ref) => approvedSpentMinor(
            ref as ApprovedSpentMinorRef,
            tripId,
          ),
          from: approvedSpentMinorProvider,
          name: r'approvedSpentMinorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$approvedSpentMinorHash,
          dependencies: ApprovedSpentMinorFamily._dependencies,
          allTransitiveDependencies:
              ApprovedSpentMinorFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  ApprovedSpentMinorProvider._internal(
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
    Stream<int> Function(ApprovedSpentMinorRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ApprovedSpentMinorProvider._internal(
        (ref) => create(ref as ApprovedSpentMinorRef),
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
  AutoDisposeStreamProviderElement<int> createElement() {
    return _ApprovedSpentMinorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApprovedSpentMinorProvider && other.tripId == tripId;
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
mixin ApprovedSpentMinorRef on AutoDisposeStreamProviderRef<int> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _ApprovedSpentMinorProviderElement
    extends AutoDisposeStreamProviderElement<int> with ApprovedSpentMinorRef {
  _ApprovedSpentMinorProviderElement(super.provider);

  @override
  String get tripId => (origin as ApprovedSpentMinorProvider).tripId;
}

String _$approvedExpensesDetailedHash() =>
    r'56dae5a05609812ef3dbaecc100d2236888d050d';

/// Approved expenses with splits — the public input to settlement balance
/// computation (PRD REQ-SET-01). Cross-feature reads go through this provider
/// (a feature's public API), not the expenses data layer.
///
/// Copied from [approvedExpensesDetailed].
@ProviderFor(approvedExpensesDetailed)
const approvedExpensesDetailedProvider = ApprovedExpensesDetailedFamily();

/// Approved expenses with splits — the public input to settlement balance
/// computation (PRD REQ-SET-01). Cross-feature reads go through this provider
/// (a feature's public API), not the expenses data layer.
///
/// Copied from [approvedExpensesDetailed].
class ApprovedExpensesDetailedFamily extends Family<AsyncValue<List<Expense>>> {
  /// Approved expenses with splits — the public input to settlement balance
  /// computation (PRD REQ-SET-01). Cross-feature reads go through this provider
  /// (a feature's public API), not the expenses data layer.
  ///
  /// Copied from [approvedExpensesDetailed].
  const ApprovedExpensesDetailedFamily();

  /// Approved expenses with splits — the public input to settlement balance
  /// computation (PRD REQ-SET-01). Cross-feature reads go through this provider
  /// (a feature's public API), not the expenses data layer.
  ///
  /// Copied from [approvedExpensesDetailed].
  ApprovedExpensesDetailedProvider call(
    String tripId,
  ) {
    return ApprovedExpensesDetailedProvider(
      tripId,
    );
  }

  @override
  ApprovedExpensesDetailedProvider getProviderOverride(
    covariant ApprovedExpensesDetailedProvider provider,
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
  String? get name => r'approvedExpensesDetailedProvider';
}

/// Approved expenses with splits — the public input to settlement balance
/// computation (PRD REQ-SET-01). Cross-feature reads go through this provider
/// (a feature's public API), not the expenses data layer.
///
/// Copied from [approvedExpensesDetailed].
class ApprovedExpensesDetailedProvider
    extends AutoDisposeStreamProvider<List<Expense>> {
  /// Approved expenses with splits — the public input to settlement balance
  /// computation (PRD REQ-SET-01). Cross-feature reads go through this provider
  /// (a feature's public API), not the expenses data layer.
  ///
  /// Copied from [approvedExpensesDetailed].
  ApprovedExpensesDetailedProvider(
    String tripId,
  ) : this._internal(
          (ref) => approvedExpensesDetailed(
            ref as ApprovedExpensesDetailedRef,
            tripId,
          ),
          from: approvedExpensesDetailedProvider,
          name: r'approvedExpensesDetailedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$approvedExpensesDetailedHash,
          dependencies: ApprovedExpensesDetailedFamily._dependencies,
          allTransitiveDependencies:
              ApprovedExpensesDetailedFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  ApprovedExpensesDetailedProvider._internal(
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
    Stream<List<Expense>> Function(ApprovedExpensesDetailedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ApprovedExpensesDetailedProvider._internal(
        (ref) => create(ref as ApprovedExpensesDetailedRef),
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
  AutoDisposeStreamProviderElement<List<Expense>> createElement() {
    return _ApprovedExpensesDetailedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApprovedExpensesDetailedProvider && other.tripId == tripId;
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
mixin ApprovedExpensesDetailedRef
    on AutoDisposeStreamProviderRef<List<Expense>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _ApprovedExpensesDetailedProviderElement
    extends AutoDisposeStreamProviderElement<List<Expense>>
    with ApprovedExpensesDetailedRef {
  _ApprovedExpensesDetailedProviderElement(super.provider);

  @override
  String get tripId => (origin as ApprovedExpensesDetailedProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
