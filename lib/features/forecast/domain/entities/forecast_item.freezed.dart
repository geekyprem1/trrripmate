// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forecast_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ForecastItem {
  String get id => throw _privateConstructorUsedError;
  String get tripId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get amountMinor => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of ForecastItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForecastItemCopyWith<ForecastItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForecastItemCopyWith<$Res> {
  factory $ForecastItemCopyWith(
          ForecastItem value, $Res Function(ForecastItem) then) =
      _$ForecastItemCopyWithImpl<$Res, ForecastItem>;
  @useResult
  $Res call(
      {String id,
      String tripId,
      String name,
      int amountMinor,
      DateTime createdAt});
}

/// @nodoc
class _$ForecastItemCopyWithImpl<$Res, $Val extends ForecastItem>
    implements $ForecastItemCopyWith<$Res> {
  _$ForecastItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForecastItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? name = null,
    Object? amountMinor = null,
    Object? createdAt = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForecastItemImplCopyWith<$Res>
    implements $ForecastItemCopyWith<$Res> {
  factory _$$ForecastItemImplCopyWith(
          _$ForecastItemImpl value, $Res Function(_$ForecastItemImpl) then) =
      __$$ForecastItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String tripId,
      String name,
      int amountMinor,
      DateTime createdAt});
}

/// @nodoc
class __$$ForecastItemImplCopyWithImpl<$Res>
    extends _$ForecastItemCopyWithImpl<$Res, _$ForecastItemImpl>
    implements _$$ForecastItemImplCopyWith<$Res> {
  __$$ForecastItemImplCopyWithImpl(
      _$ForecastItemImpl _value, $Res Function(_$ForecastItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ForecastItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? name = null,
    Object? amountMinor = null,
    Object? createdAt = null,
  }) {
    return _then(_$ForecastItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$ForecastItemImpl implements _ForecastItem {
  const _$ForecastItemImpl(
      {required this.id,
      required this.tripId,
      required this.name,
      required this.amountMinor,
      required this.createdAt});

  @override
  final String id;
  @override
  final String tripId;
  @override
  final String name;
  @override
  final int amountMinor;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ForecastItem(id: $id, tripId: $tripId, name: $name, amountMinor: $amountMinor, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForecastItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, tripId, name, amountMinor, createdAt);

  /// Create a copy of ForecastItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForecastItemImplCopyWith<_$ForecastItemImpl> get copyWith =>
      __$$ForecastItemImplCopyWithImpl<_$ForecastItemImpl>(this, _$identity);
}

abstract class _ForecastItem implements ForecastItem {
  const factory _ForecastItem(
      {required final String id,
      required final String tripId,
      required final String name,
      required final int amountMinor,
      required final DateTime createdAt}) = _$ForecastItemImpl;

  @override
  String get id;
  @override
  String get tripId;
  @override
  String get name;
  @override
  int get amountMinor;
  @override
  DateTime get createdAt;

  /// Create a copy of ForecastItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForecastItemImplCopyWith<_$ForecastItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
