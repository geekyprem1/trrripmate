// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settlement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Settlement {
  String get tripId => throw _privateConstructorUsedError;
  String get fromMemberId => throw _privateConstructorUsedError;
  String get toMemberId => throw _privateConstructorUsedError;
  int get amountMinor => throw _privateConstructorUsedError;
  SettlementStatus get status => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  String? get markedByMemberId => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  SettlementSyncState get syncState => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;

  /// Create a copy of Settlement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettlementCopyWith<Settlement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettlementCopyWith<$Res> {
  factory $SettlementCopyWith(
          Settlement value, $Res Function(Settlement) then) =
      _$SettlementCopyWithImpl<$Res, Settlement>;
  @useResult
  $Res call(
      {String tripId,
      String fromMemberId,
      String toMemberId,
      int amountMinor,
      SettlementStatus status,
      String? id,
      String? markedByMemberId,
      DateTime? completedAt,
      SettlementSyncState syncState,
      int version});
}

/// @nodoc
class _$SettlementCopyWithImpl<$Res, $Val extends Settlement>
    implements $SettlementCopyWith<$Res> {
  _$SettlementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Settlement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? fromMemberId = null,
    Object? toMemberId = null,
    Object? amountMinor = null,
    Object? status = null,
    Object? id = freezed,
    Object? markedByMemberId = freezed,
    Object? completedAt = freezed,
    Object? syncState = null,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      fromMemberId: null == fromMemberId
          ? _value.fromMemberId
          : fromMemberId // ignore: cast_nullable_to_non_nullable
              as String,
      toMemberId: null == toMemberId
          ? _value.toMemberId
          : toMemberId // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SettlementStatus,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      markedByMemberId: freezed == markedByMemberId
          ? _value.markedByMemberId
          : markedByMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      syncState: null == syncState
          ? _value.syncState
          : syncState // ignore: cast_nullable_to_non_nullable
              as SettlementSyncState,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettlementImplCopyWith<$Res>
    implements $SettlementCopyWith<$Res> {
  factory _$$SettlementImplCopyWith(
          _$SettlementImpl value, $Res Function(_$SettlementImpl) then) =
      __$$SettlementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tripId,
      String fromMemberId,
      String toMemberId,
      int amountMinor,
      SettlementStatus status,
      String? id,
      String? markedByMemberId,
      DateTime? completedAt,
      SettlementSyncState syncState,
      int version});
}

/// @nodoc
class __$$SettlementImplCopyWithImpl<$Res>
    extends _$SettlementCopyWithImpl<$Res, _$SettlementImpl>
    implements _$$SettlementImplCopyWith<$Res> {
  __$$SettlementImplCopyWithImpl(
      _$SettlementImpl _value, $Res Function(_$SettlementImpl) _then)
      : super(_value, _then);

  /// Create a copy of Settlement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? fromMemberId = null,
    Object? toMemberId = null,
    Object? amountMinor = null,
    Object? status = null,
    Object? id = freezed,
    Object? markedByMemberId = freezed,
    Object? completedAt = freezed,
    Object? syncState = null,
    Object? version = null,
  }) {
    return _then(_$SettlementImpl(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      fromMemberId: null == fromMemberId
          ? _value.fromMemberId
          : fromMemberId // ignore: cast_nullable_to_non_nullable
              as String,
      toMemberId: null == toMemberId
          ? _value.toMemberId
          : toMemberId // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SettlementStatus,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      markedByMemberId: freezed == markedByMemberId
          ? _value.markedByMemberId
          : markedByMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      syncState: null == syncState
          ? _value.syncState
          : syncState // ignore: cast_nullable_to_non_nullable
              as SettlementSyncState,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SettlementImpl extends _Settlement {
  const _$SettlementImpl(
      {required this.tripId,
      required this.fromMemberId,
      required this.toMemberId,
      required this.amountMinor,
      required this.status,
      this.id,
      this.markedByMemberId,
      this.completedAt,
      this.syncState = SettlementSyncState.synced,
      this.version = 1})
      : super._();

  @override
  final String tripId;
  @override
  final String fromMemberId;
  @override
  final String toMemberId;
  @override
  final int amountMinor;
  @override
  final SettlementStatus status;
  @override
  final String? id;
  @override
  final String? markedByMemberId;
  @override
  final DateTime? completedAt;
  @override
  @JsonKey()
  final SettlementSyncState syncState;
  @override
  @JsonKey()
  final int version;

  @override
  String toString() {
    return 'Settlement(tripId: $tripId, fromMemberId: $fromMemberId, toMemberId: $toMemberId, amountMinor: $amountMinor, status: $status, id: $id, markedByMemberId: $markedByMemberId, completedAt: $completedAt, syncState: $syncState, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettlementImpl &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.fromMemberId, fromMemberId) ||
                other.fromMemberId == fromMemberId) &&
            (identical(other.toMemberId, toMemberId) ||
                other.toMemberId == toMemberId) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.markedByMemberId, markedByMemberId) ||
                other.markedByMemberId == markedByMemberId) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.syncState, syncState) ||
                other.syncState == syncState) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      tripId,
      fromMemberId,
      toMemberId,
      amountMinor,
      status,
      id,
      markedByMemberId,
      completedAt,
      syncState,
      version);

  /// Create a copy of Settlement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettlementImplCopyWith<_$SettlementImpl> get copyWith =>
      __$$SettlementImplCopyWithImpl<_$SettlementImpl>(this, _$identity);
}

abstract class _Settlement extends Settlement {
  const factory _Settlement(
      {required final String tripId,
      required final String fromMemberId,
      required final String toMemberId,
      required final int amountMinor,
      required final SettlementStatus status,
      final String? id,
      final String? markedByMemberId,
      final DateTime? completedAt,
      final SettlementSyncState syncState,
      final int version}) = _$SettlementImpl;
  const _Settlement._() : super._();

  @override
  String get tripId;
  @override
  String get fromMemberId;
  @override
  String get toMemberId;
  @override
  int get amountMinor;
  @override
  SettlementStatus get status;
  @override
  String? get id;
  @override
  String? get markedByMemberId;
  @override
  DateTime? get completedAt;
  @override
  SettlementSyncState get syncState;
  @override
  int get version;

  /// Create a copy of Settlement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettlementImplCopyWith<_$SettlementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
