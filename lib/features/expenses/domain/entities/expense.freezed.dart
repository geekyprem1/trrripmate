// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExpenseSplit {
  String get memberId => throw _privateConstructorUsedError;
  int get shareMinor => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseSplit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseSplitCopyWith<ExpenseSplit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseSplitCopyWith<$Res> {
  factory $ExpenseSplitCopyWith(
          ExpenseSplit value, $Res Function(ExpenseSplit) then) =
      _$ExpenseSplitCopyWithImpl<$Res, ExpenseSplit>;
  @useResult
  $Res call({String memberId, int shareMinor});
}

/// @nodoc
class _$ExpenseSplitCopyWithImpl<$Res, $Val extends ExpenseSplit>
    implements $ExpenseSplitCopyWith<$Res> {
  _$ExpenseSplitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseSplit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? shareMinor = null,
  }) {
    return _then(_value.copyWith(
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      shareMinor: null == shareMinor
          ? _value.shareMinor
          : shareMinor // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseSplitImplCopyWith<$Res>
    implements $ExpenseSplitCopyWith<$Res> {
  factory _$$ExpenseSplitImplCopyWith(
          _$ExpenseSplitImpl value, $Res Function(_$ExpenseSplitImpl) then) =
      __$$ExpenseSplitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String memberId, int shareMinor});
}

/// @nodoc
class __$$ExpenseSplitImplCopyWithImpl<$Res>
    extends _$ExpenseSplitCopyWithImpl<$Res, _$ExpenseSplitImpl>
    implements _$$ExpenseSplitImplCopyWith<$Res> {
  __$$ExpenseSplitImplCopyWithImpl(
      _$ExpenseSplitImpl _value, $Res Function(_$ExpenseSplitImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseSplit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? shareMinor = null,
  }) {
    return _then(_$ExpenseSplitImpl(
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      shareMinor: null == shareMinor
          ? _value.shareMinor
          : shareMinor // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ExpenseSplitImpl implements _ExpenseSplit {
  const _$ExpenseSplitImpl({required this.memberId, required this.shareMinor});

  @override
  final String memberId;
  @override
  final int shareMinor;

  @override
  String toString() {
    return 'ExpenseSplit(memberId: $memberId, shareMinor: $shareMinor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseSplitImpl &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.shareMinor, shareMinor) ||
                other.shareMinor == shareMinor));
  }

  @override
  int get hashCode => Object.hash(runtimeType, memberId, shareMinor);

  /// Create a copy of ExpenseSplit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseSplitImplCopyWith<_$ExpenseSplitImpl> get copyWith =>
      __$$ExpenseSplitImplCopyWithImpl<_$ExpenseSplitImpl>(this, _$identity);
}

abstract class _ExpenseSplit implements ExpenseSplit {
  const factory _ExpenseSplit(
      {required final String memberId,
      required final int shareMinor}) = _$ExpenseSplitImpl;

  @override
  String get memberId;
  @override
  int get shareMinor;

  /// Create a copy of ExpenseSplit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseSplitImplCopyWith<_$ExpenseSplitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Expense {
  String get id => throw _privateConstructorUsedError;
  String get tripId => throw _privateConstructorUsedError;
  String get paidByMemberId => throw _privateConstructorUsedError;
  int get amountMinor => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  ExpenseCategory get category => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  ExpenseStatus get status => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  List<ExpenseSplit> get splits => throw _privateConstructorUsedError;
  ExpenseSyncState get syncState => throw _privateConstructorUsedError;
  ReceiptStatus get receiptStatus => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get receiptLocalPath => throw _privateConstructorUsedError;
  String? get receiptStoragePath => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseCopyWith<Expense> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseCopyWith<$Res> {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) then) =
      _$ExpenseCopyWithImpl<$Res, Expense>;
  @useResult
  $Res call(
      {String id,
      String tripId,
      String paidByMemberId,
      int amountMinor,
      String currency,
      ExpenseCategory category,
      DateTime date,
      ExpenseStatus status,
      String createdBy,
      List<ExpenseSplit> splits,
      ExpenseSyncState syncState,
      ReceiptStatus receiptStatus,
      String? description,
      String? receiptLocalPath,
      String? receiptStoragePath,
      int version});
}

/// @nodoc
class _$ExpenseCopyWithImpl<$Res, $Val extends Expense>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? paidByMemberId = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? category = null,
    Object? date = null,
    Object? status = null,
    Object? createdBy = null,
    Object? splits = null,
    Object? syncState = null,
    Object? receiptStatus = null,
    Object? description = freezed,
    Object? receiptLocalPath = freezed,
    Object? receiptStoragePath = freezed,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      paidByMemberId: null == paidByMemberId
          ? _value.paidByMemberId
          : paidByMemberId // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ExpenseCategory,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ExpenseStatus,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      splits: null == splits
          ? _value.splits
          : splits // ignore: cast_nullable_to_non_nullable
              as List<ExpenseSplit>,
      syncState: null == syncState
          ? _value.syncState
          : syncState // ignore: cast_nullable_to_non_nullable
              as ExpenseSyncState,
      receiptStatus: null == receiptStatus
          ? _value.receiptStatus
          : receiptStatus // ignore: cast_nullable_to_non_nullable
              as ReceiptStatus,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptLocalPath: freezed == receiptLocalPath
          ? _value.receiptLocalPath
          : receiptLocalPath // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptStoragePath: freezed == receiptStoragePath
          ? _value.receiptStoragePath
          : receiptStoragePath // ignore: cast_nullable_to_non_nullable
              as String?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseImplCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$$ExpenseImplCopyWith(
          _$ExpenseImpl value, $Res Function(_$ExpenseImpl) then) =
      __$$ExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String tripId,
      String paidByMemberId,
      int amountMinor,
      String currency,
      ExpenseCategory category,
      DateTime date,
      ExpenseStatus status,
      String createdBy,
      List<ExpenseSplit> splits,
      ExpenseSyncState syncState,
      ReceiptStatus receiptStatus,
      String? description,
      String? receiptLocalPath,
      String? receiptStoragePath,
      int version});
}

/// @nodoc
class __$$ExpenseImplCopyWithImpl<$Res>
    extends _$ExpenseCopyWithImpl<$Res, _$ExpenseImpl>
    implements _$$ExpenseImplCopyWith<$Res> {
  __$$ExpenseImplCopyWithImpl(
      _$ExpenseImpl _value, $Res Function(_$ExpenseImpl) _then)
      : super(_value, _then);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? paidByMemberId = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? category = null,
    Object? date = null,
    Object? status = null,
    Object? createdBy = null,
    Object? splits = null,
    Object? syncState = null,
    Object? receiptStatus = null,
    Object? description = freezed,
    Object? receiptLocalPath = freezed,
    Object? receiptStoragePath = freezed,
    Object? version = null,
  }) {
    return _then(_$ExpenseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      paidByMemberId: null == paidByMemberId
          ? _value.paidByMemberId
          : paidByMemberId // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ExpenseCategory,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ExpenseStatus,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      splits: null == splits
          ? _value._splits
          : splits // ignore: cast_nullable_to_non_nullable
              as List<ExpenseSplit>,
      syncState: null == syncState
          ? _value.syncState
          : syncState // ignore: cast_nullable_to_non_nullable
              as ExpenseSyncState,
      receiptStatus: null == receiptStatus
          ? _value.receiptStatus
          : receiptStatus // ignore: cast_nullable_to_non_nullable
              as ReceiptStatus,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptLocalPath: freezed == receiptLocalPath
          ? _value.receiptLocalPath
          : receiptLocalPath // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptStoragePath: freezed == receiptStoragePath
          ? _value.receiptStoragePath
          : receiptStoragePath // ignore: cast_nullable_to_non_nullable
              as String?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ExpenseImpl extends _Expense {
  const _$ExpenseImpl(
      {required this.id,
      required this.tripId,
      required this.paidByMemberId,
      required this.amountMinor,
      required this.currency,
      required this.category,
      required this.date,
      required this.status,
      required this.createdBy,
      final List<ExpenseSplit> splits = const <ExpenseSplit>[],
      this.syncState = ExpenseSyncState.synced,
      this.receiptStatus = ReceiptStatus.none,
      this.description,
      this.receiptLocalPath,
      this.receiptStoragePath,
      this.version = 1})
      : _splits = splits,
        super._();

  @override
  final String id;
  @override
  final String tripId;
  @override
  final String paidByMemberId;
  @override
  final int amountMinor;
  @override
  final String currency;
  @override
  final ExpenseCategory category;
  @override
  final DateTime date;
  @override
  final ExpenseStatus status;
  @override
  final String createdBy;
  final List<ExpenseSplit> _splits;
  @override
  @JsonKey()
  List<ExpenseSplit> get splits {
    if (_splits is EqualUnmodifiableListView) return _splits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_splits);
  }

  @override
  @JsonKey()
  final ExpenseSyncState syncState;
  @override
  @JsonKey()
  final ReceiptStatus receiptStatus;
  @override
  final String? description;
  @override
  final String? receiptLocalPath;
  @override
  final String? receiptStoragePath;
  @override
  @JsonKey()
  final int version;

  @override
  String toString() {
    return 'Expense(id: $id, tripId: $tripId, paidByMemberId: $paidByMemberId, amountMinor: $amountMinor, currency: $currency, category: $category, date: $date, status: $status, createdBy: $createdBy, splits: $splits, syncState: $syncState, receiptStatus: $receiptStatus, description: $description, receiptLocalPath: $receiptLocalPath, receiptStoragePath: $receiptStoragePath, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.paidByMemberId, paidByMemberId) ||
                other.paidByMemberId == paidByMemberId) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other._splits, _splits) &&
            (identical(other.syncState, syncState) ||
                other.syncState == syncState) &&
            (identical(other.receiptStatus, receiptStatus) ||
                other.receiptStatus == receiptStatus) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.receiptLocalPath, receiptLocalPath) ||
                other.receiptLocalPath == receiptLocalPath) &&
            (identical(other.receiptStoragePath, receiptStoragePath) ||
                other.receiptStoragePath == receiptStoragePath) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      tripId,
      paidByMemberId,
      amountMinor,
      currency,
      category,
      date,
      status,
      createdBy,
      const DeepCollectionEquality().hash(_splits),
      syncState,
      receiptStatus,
      description,
      receiptLocalPath,
      receiptStoragePath,
      version);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseImplCopyWith<_$ExpenseImpl> get copyWith =>
      __$$ExpenseImplCopyWithImpl<_$ExpenseImpl>(this, _$identity);
}

abstract class _Expense extends Expense {
  const factory _Expense(
      {required final String id,
      required final String tripId,
      required final String paidByMemberId,
      required final int amountMinor,
      required final String currency,
      required final ExpenseCategory category,
      required final DateTime date,
      required final ExpenseStatus status,
      required final String createdBy,
      final List<ExpenseSplit> splits,
      final ExpenseSyncState syncState,
      final ReceiptStatus receiptStatus,
      final String? description,
      final String? receiptLocalPath,
      final String? receiptStoragePath,
      final int version}) = _$ExpenseImpl;
  const _Expense._() : super._();

  @override
  String get id;
  @override
  String get tripId;
  @override
  String get paidByMemberId;
  @override
  int get amountMinor;
  @override
  String get currency;
  @override
  ExpenseCategory get category;
  @override
  DateTime get date;
  @override
  ExpenseStatus get status;
  @override
  String get createdBy;
  @override
  List<ExpenseSplit> get splits;
  @override
  ExpenseSyncState get syncState;
  @override
  ReceiptStatus get receiptStatus;
  @override
  String? get description;
  @override
  String? get receiptLocalPath;
  @override
  String? get receiptStoragePath;
  @override
  int get version;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseImplCopyWith<_$ExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
