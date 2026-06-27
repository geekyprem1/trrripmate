// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BudgetSummary {
  String get currency => throw _privateConstructorUsedError;
  int get spentMinor => throw _privateConstructorUsedError;
  int get dailySpendMinor => throw _privateConstructorUsedError;
  bool get overBudget => throw _privateConstructorUsedError;
  int? get totalMinor => throw _privateConstructorUsedError;
  int? get remainingMinor => throw _privateConstructorUsedError;

  /// Create a copy of BudgetSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetSummaryCopyWith<BudgetSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetSummaryCopyWith<$Res> {
  factory $BudgetSummaryCopyWith(
          BudgetSummary value, $Res Function(BudgetSummary) then) =
      _$BudgetSummaryCopyWithImpl<$Res, BudgetSummary>;
  @useResult
  $Res call(
      {String currency,
      int spentMinor,
      int dailySpendMinor,
      bool overBudget,
      int? totalMinor,
      int? remainingMinor});
}

/// @nodoc
class _$BudgetSummaryCopyWithImpl<$Res, $Val extends BudgetSummary>
    implements $BudgetSummaryCopyWith<$Res> {
  _$BudgetSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currency = null,
    Object? spentMinor = null,
    Object? dailySpendMinor = null,
    Object? overBudget = null,
    Object? totalMinor = freezed,
    Object? remainingMinor = freezed,
  }) {
    return _then(_value.copyWith(
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      spentMinor: null == spentMinor
          ? _value.spentMinor
          : spentMinor // ignore: cast_nullable_to_non_nullable
              as int,
      dailySpendMinor: null == dailySpendMinor
          ? _value.dailySpendMinor
          : dailySpendMinor // ignore: cast_nullable_to_non_nullable
              as int,
      overBudget: null == overBudget
          ? _value.overBudget
          : overBudget // ignore: cast_nullable_to_non_nullable
              as bool,
      totalMinor: freezed == totalMinor
          ? _value.totalMinor
          : totalMinor // ignore: cast_nullable_to_non_nullable
              as int?,
      remainingMinor: freezed == remainingMinor
          ? _value.remainingMinor
          : remainingMinor // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetSummaryImplCopyWith<$Res>
    implements $BudgetSummaryCopyWith<$Res> {
  factory _$$BudgetSummaryImplCopyWith(
          _$BudgetSummaryImpl value, $Res Function(_$BudgetSummaryImpl) then) =
      __$$BudgetSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String currency,
      int spentMinor,
      int dailySpendMinor,
      bool overBudget,
      int? totalMinor,
      int? remainingMinor});
}

/// @nodoc
class __$$BudgetSummaryImplCopyWithImpl<$Res>
    extends _$BudgetSummaryCopyWithImpl<$Res, _$BudgetSummaryImpl>
    implements _$$BudgetSummaryImplCopyWith<$Res> {
  __$$BudgetSummaryImplCopyWithImpl(
      _$BudgetSummaryImpl _value, $Res Function(_$BudgetSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currency = null,
    Object? spentMinor = null,
    Object? dailySpendMinor = null,
    Object? overBudget = null,
    Object? totalMinor = freezed,
    Object? remainingMinor = freezed,
  }) {
    return _then(_$BudgetSummaryImpl(
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      spentMinor: null == spentMinor
          ? _value.spentMinor
          : spentMinor // ignore: cast_nullable_to_non_nullable
              as int,
      dailySpendMinor: null == dailySpendMinor
          ? _value.dailySpendMinor
          : dailySpendMinor // ignore: cast_nullable_to_non_nullable
              as int,
      overBudget: null == overBudget
          ? _value.overBudget
          : overBudget // ignore: cast_nullable_to_non_nullable
              as bool,
      totalMinor: freezed == totalMinor
          ? _value.totalMinor
          : totalMinor // ignore: cast_nullable_to_non_nullable
              as int?,
      remainingMinor: freezed == remainingMinor
          ? _value.remainingMinor
          : remainingMinor // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$BudgetSummaryImpl extends _BudgetSummary {
  const _$BudgetSummaryImpl(
      {required this.currency,
      required this.spentMinor,
      required this.dailySpendMinor,
      required this.overBudget,
      this.totalMinor,
      this.remainingMinor})
      : super._();

  @override
  final String currency;
  @override
  final int spentMinor;
  @override
  final int dailySpendMinor;
  @override
  final bool overBudget;
  @override
  final int? totalMinor;
  @override
  final int? remainingMinor;

  @override
  String toString() {
    return 'BudgetSummary(currency: $currency, spentMinor: $spentMinor, dailySpendMinor: $dailySpendMinor, overBudget: $overBudget, totalMinor: $totalMinor, remainingMinor: $remainingMinor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetSummaryImpl &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.spentMinor, spentMinor) ||
                other.spentMinor == spentMinor) &&
            (identical(other.dailySpendMinor, dailySpendMinor) ||
                other.dailySpendMinor == dailySpendMinor) &&
            (identical(other.overBudget, overBudget) ||
                other.overBudget == overBudget) &&
            (identical(other.totalMinor, totalMinor) ||
                other.totalMinor == totalMinor) &&
            (identical(other.remainingMinor, remainingMinor) ||
                other.remainingMinor == remainingMinor));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currency, spentMinor,
      dailySpendMinor, overBudget, totalMinor, remainingMinor);

  /// Create a copy of BudgetSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetSummaryImplCopyWith<_$BudgetSummaryImpl> get copyWith =>
      __$$BudgetSummaryImplCopyWithImpl<_$BudgetSummaryImpl>(this, _$identity);
}

abstract class _BudgetSummary extends BudgetSummary {
  const factory _BudgetSummary(
      {required final String currency,
      required final int spentMinor,
      required final int dailySpendMinor,
      required final bool overBudget,
      final int? totalMinor,
      final int? remainingMinor}) = _$BudgetSummaryImpl;
  const _BudgetSummary._() : super._();

  @override
  String get currency;
  @override
  int get spentMinor;
  @override
  int get dailySpendMinor;
  @override
  bool get overBudget;
  @override
  int? get totalMinor;
  @override
  int? get remainingMinor;

  /// Create a copy of BudgetSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetSummaryImplCopyWith<_$BudgetSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
