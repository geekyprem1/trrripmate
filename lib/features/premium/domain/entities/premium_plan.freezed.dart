// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'premium_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PremiumPlan {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get priceLabel => throw _privateConstructorUsedError;
  PlanPeriod get period => throw _privateConstructorUsedError;
  String? get tagline => throw _privateConstructorUsedError;

  /// Create a copy of PremiumPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PremiumPlanCopyWith<PremiumPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PremiumPlanCopyWith<$Res> {
  factory $PremiumPlanCopyWith(
          PremiumPlan value, $Res Function(PremiumPlan) then) =
      _$PremiumPlanCopyWithImpl<$Res, PremiumPlan>;
  @useResult
  $Res call(
      {String id,
      String title,
      String priceLabel,
      PlanPeriod period,
      String? tagline});
}

/// @nodoc
class _$PremiumPlanCopyWithImpl<$Res, $Val extends PremiumPlan>
    implements $PremiumPlanCopyWith<$Res> {
  _$PremiumPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PremiumPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? priceLabel = null,
    Object? period = null,
    Object? tagline = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      priceLabel: null == priceLabel
          ? _value.priceLabel
          : priceLabel // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as PlanPeriod,
      tagline: freezed == tagline
          ? _value.tagline
          : tagline // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PremiumPlanImplCopyWith<$Res>
    implements $PremiumPlanCopyWith<$Res> {
  factory _$$PremiumPlanImplCopyWith(
          _$PremiumPlanImpl value, $Res Function(_$PremiumPlanImpl) then) =
      __$$PremiumPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String priceLabel,
      PlanPeriod period,
      String? tagline});
}

/// @nodoc
class __$$PremiumPlanImplCopyWithImpl<$Res>
    extends _$PremiumPlanCopyWithImpl<$Res, _$PremiumPlanImpl>
    implements _$$PremiumPlanImplCopyWith<$Res> {
  __$$PremiumPlanImplCopyWithImpl(
      _$PremiumPlanImpl _value, $Res Function(_$PremiumPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of PremiumPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? priceLabel = null,
    Object? period = null,
    Object? tagline = freezed,
  }) {
    return _then(_$PremiumPlanImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      priceLabel: null == priceLabel
          ? _value.priceLabel
          : priceLabel // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as PlanPeriod,
      tagline: freezed == tagline
          ? _value.tagline
          : tagline // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PremiumPlanImpl extends _PremiumPlan {
  const _$PremiumPlanImpl(
      {required this.id,
      required this.title,
      required this.priceLabel,
      required this.period,
      this.tagline})
      : super._();

  @override
  final String id;
  @override
  final String title;
  @override
  final String priceLabel;
  @override
  final PlanPeriod period;
  @override
  final String? tagline;

  @override
  String toString() {
    return 'PremiumPlan(id: $id, title: $title, priceLabel: $priceLabel, period: $period, tagline: $tagline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PremiumPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.priceLabel, priceLabel) ||
                other.priceLabel == priceLabel) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.tagline, tagline) || other.tagline == tagline));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, priceLabel, period, tagline);

  /// Create a copy of PremiumPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PremiumPlanImplCopyWith<_$PremiumPlanImpl> get copyWith =>
      __$$PremiumPlanImplCopyWithImpl<_$PremiumPlanImpl>(this, _$identity);
}

abstract class _PremiumPlan extends PremiumPlan {
  const factory _PremiumPlan(
      {required final String id,
      required final String title,
      required final String priceLabel,
      required final PlanPeriod period,
      final String? tagline}) = _$PremiumPlanImpl;
  const _PremiumPlan._() : super._();

  @override
  String get id;
  @override
  String get title;
  @override
  String get priceLabel;
  @override
  PlanPeriod get period;
  @override
  String? get tagline;

  /// Create a copy of PremiumPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PremiumPlanImplCopyWith<_$PremiumPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
