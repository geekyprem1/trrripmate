// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settlement_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SettlementSummary {
  List<MemberBalance> get balances => throw _privateConstructorUsedError;
  List<Settlement> get transactions => throw _privateConstructorUsedError;

  /// The current user's net (minor units); 0 if they are not a member or are
  /// fully settled.
  int get yourNetMinor => throw _privateConstructorUsedError;

  /// Whether any approved expense exists yet — distinguishes "nothing to
  /// settle" from "all settled".
  bool get hasActivity => throw _privateConstructorUsedError;

  /// Create a copy of SettlementSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettlementSummaryCopyWith<SettlementSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettlementSummaryCopyWith<$Res> {
  factory $SettlementSummaryCopyWith(
          SettlementSummary value, $Res Function(SettlementSummary) then) =
      _$SettlementSummaryCopyWithImpl<$Res, SettlementSummary>;
  @useResult
  $Res call(
      {List<MemberBalance> balances,
      List<Settlement> transactions,
      int yourNetMinor,
      bool hasActivity});
}

/// @nodoc
class _$SettlementSummaryCopyWithImpl<$Res, $Val extends SettlementSummary>
    implements $SettlementSummaryCopyWith<$Res> {
  _$SettlementSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettlementSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balances = null,
    Object? transactions = null,
    Object? yourNetMinor = null,
    Object? hasActivity = null,
  }) {
    return _then(_value.copyWith(
      balances: null == balances
          ? _value.balances
          : balances // ignore: cast_nullable_to_non_nullable
              as List<MemberBalance>,
      transactions: null == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<Settlement>,
      yourNetMinor: null == yourNetMinor
          ? _value.yourNetMinor
          : yourNetMinor // ignore: cast_nullable_to_non_nullable
              as int,
      hasActivity: null == hasActivity
          ? _value.hasActivity
          : hasActivity // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettlementSummaryImplCopyWith<$Res>
    implements $SettlementSummaryCopyWith<$Res> {
  factory _$$SettlementSummaryImplCopyWith(_$SettlementSummaryImpl value,
          $Res Function(_$SettlementSummaryImpl) then) =
      __$$SettlementSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<MemberBalance> balances,
      List<Settlement> transactions,
      int yourNetMinor,
      bool hasActivity});
}

/// @nodoc
class __$$SettlementSummaryImplCopyWithImpl<$Res>
    extends _$SettlementSummaryCopyWithImpl<$Res, _$SettlementSummaryImpl>
    implements _$$SettlementSummaryImplCopyWith<$Res> {
  __$$SettlementSummaryImplCopyWithImpl(_$SettlementSummaryImpl _value,
      $Res Function(_$SettlementSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of SettlementSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balances = null,
    Object? transactions = null,
    Object? yourNetMinor = null,
    Object? hasActivity = null,
  }) {
    return _then(_$SettlementSummaryImpl(
      balances: null == balances
          ? _value._balances
          : balances // ignore: cast_nullable_to_non_nullable
              as List<MemberBalance>,
      transactions: null == transactions
          ? _value._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<Settlement>,
      yourNetMinor: null == yourNetMinor
          ? _value.yourNetMinor
          : yourNetMinor // ignore: cast_nullable_to_non_nullable
              as int,
      hasActivity: null == hasActivity
          ? _value.hasActivity
          : hasActivity // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SettlementSummaryImpl extends _SettlementSummary {
  const _$SettlementSummaryImpl(
      {final List<MemberBalance> balances = const <MemberBalance>[],
      final List<Settlement> transactions = const <Settlement>[],
      this.yourNetMinor = 0,
      this.hasActivity = false})
      : _balances = balances,
        _transactions = transactions,
        super._();

  final List<MemberBalance> _balances;
  @override
  @JsonKey()
  List<MemberBalance> get balances {
    if (_balances is EqualUnmodifiableListView) return _balances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_balances);
  }

  final List<Settlement> _transactions;
  @override
  @JsonKey()
  List<Settlement> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  /// The current user's net (minor units); 0 if they are not a member or are
  /// fully settled.
  @override
  @JsonKey()
  final int yourNetMinor;

  /// Whether any approved expense exists yet — distinguishes "nothing to
  /// settle" from "all settled".
  @override
  @JsonKey()
  final bool hasActivity;

  @override
  String toString() {
    return 'SettlementSummary(balances: $balances, transactions: $transactions, yourNetMinor: $yourNetMinor, hasActivity: $hasActivity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettlementSummaryImpl &&
            const DeepCollectionEquality().equals(other._balances, _balances) &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions) &&
            (identical(other.yourNetMinor, yourNetMinor) ||
                other.yourNetMinor == yourNetMinor) &&
            (identical(other.hasActivity, hasActivity) ||
                other.hasActivity == hasActivity));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_balances),
      const DeepCollectionEquality().hash(_transactions),
      yourNetMinor,
      hasActivity);

  /// Create a copy of SettlementSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettlementSummaryImplCopyWith<_$SettlementSummaryImpl> get copyWith =>
      __$$SettlementSummaryImplCopyWithImpl<_$SettlementSummaryImpl>(
          this, _$identity);
}

abstract class _SettlementSummary extends SettlementSummary {
  const factory _SettlementSummary(
      {final List<MemberBalance> balances,
      final List<Settlement> transactions,
      final int yourNetMinor,
      final bool hasActivity}) = _$SettlementSummaryImpl;
  const _SettlementSummary._() : super._();

  @override
  List<MemberBalance> get balances;
  @override
  List<Settlement> get transactions;

  /// The current user's net (minor units); 0 if they are not a member or are
  /// fully settled.
  @override
  int get yourNetMinor;

  /// Whether any approved expense exists yet — distinguishes "nothing to
  /// settle" from "all settled".
  @override
  bool get hasActivity;

  /// Create a copy of SettlementSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettlementSummaryImplCopyWith<_$SettlementSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
