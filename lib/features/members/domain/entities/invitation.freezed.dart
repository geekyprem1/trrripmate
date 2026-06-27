// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invitation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Invitation {
  String get id => throw _privateConstructorUsedError;
  String get tripId => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  InvitationStatus get status => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// Create a copy of Invitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvitationCopyWith<Invitation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvitationCopyWith<$Res> {
  factory $InvitationCopyWith(
          Invitation value, $Res Function(Invitation) then) =
      _$InvitationCopyWithImpl<$Res, Invitation>;
  @useResult
  $Res call(
      {String id,
      String tripId,
      String code,
      InvitationStatus status,
      DateTime expiresAt});
}

/// @nodoc
class _$InvitationCopyWithImpl<$Res, $Val extends Invitation>
    implements $InvitationCopyWith<$Res> {
  _$InvitationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Invitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? code = null,
    Object? status = null,
    Object? expiresAt = null,
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
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InvitationStatus,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvitationImplCopyWith<$Res>
    implements $InvitationCopyWith<$Res> {
  factory _$$InvitationImplCopyWith(
          _$InvitationImpl value, $Res Function(_$InvitationImpl) then) =
      __$$InvitationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String tripId,
      String code,
      InvitationStatus status,
      DateTime expiresAt});
}

/// @nodoc
class __$$InvitationImplCopyWithImpl<$Res>
    extends _$InvitationCopyWithImpl<$Res, _$InvitationImpl>
    implements _$$InvitationImplCopyWith<$Res> {
  __$$InvitationImplCopyWithImpl(
      _$InvitationImpl _value, $Res Function(_$InvitationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Invitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tripId = null,
    Object? code = null,
    Object? status = null,
    Object? expiresAt = null,
  }) {
    return _then(_$InvitationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InvitationStatus,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$InvitationImpl extends _Invitation {
  const _$InvitationImpl(
      {required this.id,
      required this.tripId,
      required this.code,
      required this.status,
      required this.expiresAt})
      : super._();

  @override
  final String id;
  @override
  final String tripId;
  @override
  final String code;
  @override
  final InvitationStatus status;
  @override
  final DateTime expiresAt;

  @override
  String toString() {
    return 'Invitation(id: $id, tripId: $tripId, code: $code, status: $status, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvitationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, tripId, code, status, expiresAt);

  /// Create a copy of Invitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvitationImplCopyWith<_$InvitationImpl> get copyWith =>
      __$$InvitationImplCopyWithImpl<_$InvitationImpl>(this, _$identity);
}

abstract class _Invitation extends Invitation {
  const factory _Invitation(
      {required final String id,
      required final String tripId,
      required final String code,
      required final InvitationStatus status,
      required final DateTime expiresAt}) = _$InvitationImpl;
  const _Invitation._() : super._();

  @override
  String get id;
  @override
  String get tripId;
  @override
  String get code;
  @override
  InvitationStatus get status;
  @override
  DateTime get expiresAt;

  /// Create a copy of Invitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvitationImplCopyWith<_$InvitationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InvitePreview {
  String get code => throw _privateConstructorUsedError;
  String get tripName => throw _privateConstructorUsedError;
  InvitationStatus get status => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;
  String? get ownerName => throw _privateConstructorUsedError;

  /// Create a copy of InvitePreview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvitePreviewCopyWith<InvitePreview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvitePreviewCopyWith<$Res> {
  factory $InvitePreviewCopyWith(
          InvitePreview value, $Res Function(InvitePreview) then) =
      _$InvitePreviewCopyWithImpl<$Res, InvitePreview>;
  @useResult
  $Res call(
      {String code,
      String tripName,
      InvitationStatus status,
      DateTime expiresAt,
      int memberCount,
      String? ownerName});
}

/// @nodoc
class _$InvitePreviewCopyWithImpl<$Res, $Val extends InvitePreview>
    implements $InvitePreviewCopyWith<$Res> {
  _$InvitePreviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvitePreview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? tripName = null,
    Object? status = null,
    Object? expiresAt = null,
    Object? memberCount = null,
    Object? ownerName = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      tripName: null == tripName
          ? _value.tripName
          : tripName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InvitationStatus,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      ownerName: freezed == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvitePreviewImplCopyWith<$Res>
    implements $InvitePreviewCopyWith<$Res> {
  factory _$$InvitePreviewImplCopyWith(
          _$InvitePreviewImpl value, $Res Function(_$InvitePreviewImpl) then) =
      __$$InvitePreviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      String tripName,
      InvitationStatus status,
      DateTime expiresAt,
      int memberCount,
      String? ownerName});
}

/// @nodoc
class __$$InvitePreviewImplCopyWithImpl<$Res>
    extends _$InvitePreviewCopyWithImpl<$Res, _$InvitePreviewImpl>
    implements _$$InvitePreviewImplCopyWith<$Res> {
  __$$InvitePreviewImplCopyWithImpl(
      _$InvitePreviewImpl _value, $Res Function(_$InvitePreviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of InvitePreview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? tripName = null,
    Object? status = null,
    Object? expiresAt = null,
    Object? memberCount = null,
    Object? ownerName = freezed,
  }) {
    return _then(_$InvitePreviewImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      tripName: null == tripName
          ? _value.tripName
          : tripName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InvitationStatus,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      ownerName: freezed == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$InvitePreviewImpl extends _InvitePreview {
  const _$InvitePreviewImpl(
      {required this.code,
      required this.tripName,
      required this.status,
      required this.expiresAt,
      required this.memberCount,
      this.ownerName})
      : super._();

  @override
  final String code;
  @override
  final String tripName;
  @override
  final InvitationStatus status;
  @override
  final DateTime expiresAt;
  @override
  final int memberCount;
  @override
  final String? ownerName;

  @override
  String toString() {
    return 'InvitePreview(code: $code, tripName: $tripName, status: $status, expiresAt: $expiresAt, memberCount: $memberCount, ownerName: $ownerName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvitePreviewImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.tripName, tripName) ||
                other.tripName == tripName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, code, tripName, status, expiresAt, memberCount, ownerName);

  /// Create a copy of InvitePreview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvitePreviewImplCopyWith<_$InvitePreviewImpl> get copyWith =>
      __$$InvitePreviewImplCopyWithImpl<_$InvitePreviewImpl>(this, _$identity);
}

abstract class _InvitePreview extends InvitePreview {
  const factory _InvitePreview(
      {required final String code,
      required final String tripName,
      required final InvitationStatus status,
      required final DateTime expiresAt,
      required final int memberCount,
      final String? ownerName}) = _$InvitePreviewImpl;
  const _InvitePreview._() : super._();

  @override
  String get code;
  @override
  String get tripName;
  @override
  InvitationStatus get status;
  @override
  DateTime get expiresAt;
  @override
  int get memberCount;
  @override
  String? get ownerName;

  /// Create a copy of InvitePreview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvitePreviewImplCopyWith<_$InvitePreviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
