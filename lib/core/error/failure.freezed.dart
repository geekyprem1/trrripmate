// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Failure {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message) permission,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message) conflict,
    required TResult Function(String message) storage,
    required TResult Function(String message) quota,
    required TResult Function(String message) ai,
    required TResult Function(String message) configuration,
    required TResult Function(String message) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message)? permission,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message)? conflict,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? quota,
    TResult? Function(String message)? ai,
    TResult? Function(String message)? configuration,
    TResult? Function(String message)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message)? permission,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message)? conflict,
    TResult Function(String message)? storage,
    TResult Function(String message)? quota,
    TResult Function(String message)? ai,
    TResult Function(String message)? configuration,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(ConflictFailure value) conflict,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(QuotaFailure value) quota,
    required TResult Function(AiFailure value) ai,
    required TResult Function(ConfigurationFailure value) configuration,
    required TResult Function(UnknownFailure value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(ConflictFailure value)? conflict,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(QuotaFailure value)? quota,
    TResult? Function(AiFailure value)? ai,
    TResult? Function(ConfigurationFailure value)? configuration,
    TResult? Function(UnknownFailure value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(ConflictFailure value)? conflict,
    TResult Function(StorageFailure value)? storage,
    TResult Function(QuotaFailure value)? quota,
    TResult Function(AiFailure value)? ai,
    TResult Function(ConfigurationFailure value)? configuration,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FailureCopyWith<Failure> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(_$NetworkFailureImpl value,
          $Res Function(_$NetworkFailureImpl) then) =
      __$$NetworkFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
      _$NetworkFailureImpl _value, $Res Function(_$NetworkFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$NetworkFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NetworkFailureImpl implements NetworkFailure {
  const _$NetworkFailureImpl({this.message = 'No internet connection.'});

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'Failure.network(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      __$$NetworkFailureImplCopyWithImpl<_$NetworkFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message) permission,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message) conflict,
    required TResult Function(String message) storage,
    required TResult Function(String message) quota,
    required TResult Function(String message) ai,
    required TResult Function(String message) configuration,
    required TResult Function(String message) unknown,
  }) {
    return network(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message)? permission,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message)? conflict,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? quota,
    TResult? Function(String message)? ai,
    TResult? Function(String message)? configuration,
    TResult? Function(String message)? unknown,
  }) {
    return network?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message)? permission,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message)? conflict,
    TResult Function(String message)? storage,
    TResult Function(String message)? quota,
    TResult Function(String message)? ai,
    TResult Function(String message)? configuration,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(ConflictFailure value) conflict,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(QuotaFailure value) quota,
    required TResult Function(AiFailure value) ai,
    required TResult Function(ConfigurationFailure value) configuration,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(ConflictFailure value)? conflict,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(QuotaFailure value)? quota,
    TResult? Function(AiFailure value)? ai,
    TResult? Function(ConfigurationFailure value)? configuration,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(ConflictFailure value)? conflict,
    TResult Function(StorageFailure value)? storage,
    TResult Function(QuotaFailure value)? quota,
    TResult Function(AiFailure value)? ai,
    TResult Function(ConfigurationFailure value)? configuration,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkFailure implements Failure {
  const factory NetworkFailure({final String message}) = _$NetworkFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$AuthFailureImplCopyWith(
          _$AuthFailureImpl value, $Res Function(_$AuthFailureImpl) then) =
      __$$AuthFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? code});
}

/// @nodoc
class __$$AuthFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$AuthFailureImpl>
    implements _$$AuthFailureImplCopyWith<$Res> {
  __$$AuthFailureImplCopyWithImpl(
      _$AuthFailureImpl _value, $Res Function(_$AuthFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? code = freezed,
  }) {
    return _then(_$AuthFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AuthFailureImpl implements AuthFailure {
  const _$AuthFailureImpl({required this.message, this.code});

  @override
  final String message;
  @override
  final String? code;

  @override
  String toString() {
    return 'Failure.auth(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthFailureImplCopyWith<_$AuthFailureImpl> get copyWith =>
      __$$AuthFailureImplCopyWithImpl<_$AuthFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message) permission,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message) conflict,
    required TResult Function(String message) storage,
    required TResult Function(String message) quota,
    required TResult Function(String message) ai,
    required TResult Function(String message) configuration,
    required TResult Function(String message) unknown,
  }) {
    return auth(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message)? permission,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message)? conflict,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? quota,
    TResult? Function(String message)? ai,
    TResult? Function(String message)? configuration,
    TResult? Function(String message)? unknown,
  }) {
    return auth?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message)? permission,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message)? conflict,
    TResult Function(String message)? storage,
    TResult Function(String message)? quota,
    TResult Function(String message)? ai,
    TResult Function(String message)? configuration,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (auth != null) {
      return auth(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(ConflictFailure value) conflict,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(QuotaFailure value) quota,
    required TResult Function(AiFailure value) ai,
    required TResult Function(ConfigurationFailure value) configuration,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return auth(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(ConflictFailure value)? conflict,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(QuotaFailure value)? quota,
    TResult? Function(AiFailure value)? ai,
    TResult? Function(ConfigurationFailure value)? configuration,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return auth?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(ConflictFailure value)? conflict,
    TResult Function(StorageFailure value)? storage,
    TResult Function(QuotaFailure value)? quota,
    TResult Function(AiFailure value)? ai,
    TResult Function(ConfigurationFailure value)? configuration,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (auth != null) {
      return auth(this);
    }
    return orElse();
  }
}

abstract class AuthFailure implements Failure {
  const factory AuthFailure(
      {required final String message, final String? code}) = _$AuthFailureImpl;

  @override
  String get message;
  String? get code;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthFailureImplCopyWith<_$AuthFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PermissionFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$PermissionFailureImplCopyWith(_$PermissionFailureImpl value,
          $Res Function(_$PermissionFailureImpl) then) =
      __$$PermissionFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PermissionFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$PermissionFailureImpl>
    implements _$$PermissionFailureImplCopyWith<$Res> {
  __$$PermissionFailureImplCopyWithImpl(_$PermissionFailureImpl _value,
      $Res Function(_$PermissionFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$PermissionFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PermissionFailureImpl implements PermissionFailure {
  const _$PermissionFailureImpl(
      {this.message = 'You do not have permission for this action.'});

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'Failure.permission(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionFailureImplCopyWith<_$PermissionFailureImpl> get copyWith =>
      __$$PermissionFailureImplCopyWithImpl<_$PermissionFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message) permission,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message) conflict,
    required TResult Function(String message) storage,
    required TResult Function(String message) quota,
    required TResult Function(String message) ai,
    required TResult Function(String message) configuration,
    required TResult Function(String message) unknown,
  }) {
    return permission(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message)? permission,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message)? conflict,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? quota,
    TResult? Function(String message)? ai,
    TResult? Function(String message)? configuration,
    TResult? Function(String message)? unknown,
  }) {
    return permission?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message)? permission,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message)? conflict,
    TResult Function(String message)? storage,
    TResult Function(String message)? quota,
    TResult Function(String message)? ai,
    TResult Function(String message)? configuration,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(ConflictFailure value) conflict,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(QuotaFailure value) quota,
    required TResult Function(AiFailure value) ai,
    required TResult Function(ConfigurationFailure value) configuration,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return permission(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(ConflictFailure value)? conflict,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(QuotaFailure value)? quota,
    TResult? Function(AiFailure value)? ai,
    TResult? Function(ConfigurationFailure value)? configuration,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return permission?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(ConflictFailure value)? conflict,
    TResult Function(StorageFailure value)? storage,
    TResult Function(QuotaFailure value)? quota,
    TResult Function(AiFailure value)? ai,
    TResult Function(ConfigurationFailure value)? configuration,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(this);
    }
    return orElse();
  }
}

abstract class PermissionFailure implements Failure {
  const factory PermissionFailure({final String message}) =
      _$PermissionFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionFailureImplCopyWith<_$PermissionFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ValidationFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$ValidationFailureImplCopyWith(_$ValidationFailureImpl value,
          $Res Function(_$ValidationFailureImpl) then) =
      __$$ValidationFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? field});
}

/// @nodoc
class __$$ValidationFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ValidationFailureImpl>
    implements _$$ValidationFailureImplCopyWith<$Res> {
  __$$ValidationFailureImplCopyWithImpl(_$ValidationFailureImpl _value,
      $Res Function(_$ValidationFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? field = freezed,
  }) {
    return _then(_$ValidationFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      field: freezed == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ValidationFailureImpl implements ValidationFailure {
  const _$ValidationFailureImpl({required this.message, this.field});

  @override
  final String message;
  @override
  final String? field;

  @override
  String toString() {
    return 'Failure.validation(message: $message, field: $field)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.field, field) || other.field == field));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, field);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      __$$ValidationFailureImplCopyWithImpl<_$ValidationFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message) permission,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message) conflict,
    required TResult Function(String message) storage,
    required TResult Function(String message) quota,
    required TResult Function(String message) ai,
    required TResult Function(String message) configuration,
    required TResult Function(String message) unknown,
  }) {
    return validation(message, field);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message)? permission,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message)? conflict,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? quota,
    TResult? Function(String message)? ai,
    TResult? Function(String message)? configuration,
    TResult? Function(String message)? unknown,
  }) {
    return validation?.call(message, field);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message)? permission,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message)? conflict,
    TResult Function(String message)? storage,
    TResult Function(String message)? quota,
    TResult Function(String message)? ai,
    TResult Function(String message)? configuration,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(message, field);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(ConflictFailure value) conflict,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(QuotaFailure value) quota,
    required TResult Function(AiFailure value) ai,
    required TResult Function(ConfigurationFailure value) configuration,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return validation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(ConflictFailure value)? conflict,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(QuotaFailure value)? quota,
    TResult? Function(AiFailure value)? ai,
    TResult? Function(ConfigurationFailure value)? configuration,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return validation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(ConflictFailure value)? conflict,
    TResult Function(StorageFailure value)? storage,
    TResult Function(QuotaFailure value)? quota,
    TResult Function(AiFailure value)? ai,
    TResult Function(ConfigurationFailure value)? configuration,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(this);
    }
    return orElse();
  }
}

abstract class ValidationFailure implements Failure {
  const factory ValidationFailure(
      {required final String message,
      final String? field}) = _$ValidationFailureImpl;

  @override
  String get message;
  String? get field;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConflictFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$ConflictFailureImplCopyWith(_$ConflictFailureImpl value,
          $Res Function(_$ConflictFailureImpl) then) =
      __$$ConflictFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ConflictFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ConflictFailureImpl>
    implements _$$ConflictFailureImplCopyWith<$Res> {
  __$$ConflictFailureImplCopyWithImpl(
      _$ConflictFailureImpl _value, $Res Function(_$ConflictFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ConflictFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ConflictFailureImpl implements ConflictFailure {
  const _$ConflictFailureImpl(
      {this.message = 'This item changed elsewhere. Please retry.'});

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'Failure.conflict(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConflictFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConflictFailureImplCopyWith<_$ConflictFailureImpl> get copyWith =>
      __$$ConflictFailureImplCopyWithImpl<_$ConflictFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message) permission,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message) conflict,
    required TResult Function(String message) storage,
    required TResult Function(String message) quota,
    required TResult Function(String message) ai,
    required TResult Function(String message) configuration,
    required TResult Function(String message) unknown,
  }) {
    return conflict(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message)? permission,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message)? conflict,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? quota,
    TResult? Function(String message)? ai,
    TResult? Function(String message)? configuration,
    TResult? Function(String message)? unknown,
  }) {
    return conflict?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message)? permission,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message)? conflict,
    TResult Function(String message)? storage,
    TResult Function(String message)? quota,
    TResult Function(String message)? ai,
    TResult Function(String message)? configuration,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (conflict != null) {
      return conflict(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(ConflictFailure value) conflict,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(QuotaFailure value) quota,
    required TResult Function(AiFailure value) ai,
    required TResult Function(ConfigurationFailure value) configuration,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return conflict(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(ConflictFailure value)? conflict,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(QuotaFailure value)? quota,
    TResult? Function(AiFailure value)? ai,
    TResult? Function(ConfigurationFailure value)? configuration,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return conflict?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(ConflictFailure value)? conflict,
    TResult Function(StorageFailure value)? storage,
    TResult Function(QuotaFailure value)? quota,
    TResult Function(AiFailure value)? ai,
    TResult Function(ConfigurationFailure value)? configuration,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (conflict != null) {
      return conflict(this);
    }
    return orElse();
  }
}

abstract class ConflictFailure implements Failure {
  const factory ConflictFailure({final String message}) = _$ConflictFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConflictFailureImplCopyWith<_$ConflictFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StorageFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$StorageFailureImplCopyWith(_$StorageFailureImpl value,
          $Res Function(_$StorageFailureImpl) then) =
      __$$StorageFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$StorageFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$StorageFailureImpl>
    implements _$$StorageFailureImplCopyWith<$Res> {
  __$$StorageFailureImplCopyWithImpl(
      _$StorageFailureImpl _value, $Res Function(_$StorageFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$StorageFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StorageFailureImpl implements StorageFailure {
  const _$StorageFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.storage(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorageFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorageFailureImplCopyWith<_$StorageFailureImpl> get copyWith =>
      __$$StorageFailureImplCopyWithImpl<_$StorageFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message) permission,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message) conflict,
    required TResult Function(String message) storage,
    required TResult Function(String message) quota,
    required TResult Function(String message) ai,
    required TResult Function(String message) configuration,
    required TResult Function(String message) unknown,
  }) {
    return storage(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message)? permission,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message)? conflict,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? quota,
    TResult? Function(String message)? ai,
    TResult? Function(String message)? configuration,
    TResult? Function(String message)? unknown,
  }) {
    return storage?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message)? permission,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message)? conflict,
    TResult Function(String message)? storage,
    TResult Function(String message)? quota,
    TResult Function(String message)? ai,
    TResult Function(String message)? configuration,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(ConflictFailure value) conflict,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(QuotaFailure value) quota,
    required TResult Function(AiFailure value) ai,
    required TResult Function(ConfigurationFailure value) configuration,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return storage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(ConflictFailure value)? conflict,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(QuotaFailure value)? quota,
    TResult? Function(AiFailure value)? ai,
    TResult? Function(ConfigurationFailure value)? configuration,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return storage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(ConflictFailure value)? conflict,
    TResult Function(StorageFailure value)? storage,
    TResult Function(QuotaFailure value)? quota,
    TResult Function(AiFailure value)? ai,
    TResult Function(ConfigurationFailure value)? configuration,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage(this);
    }
    return orElse();
  }
}

abstract class StorageFailure implements Failure {
  const factory StorageFailure({required final String message}) =
      _$StorageFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorageFailureImplCopyWith<_$StorageFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$QuotaFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$QuotaFailureImplCopyWith(
          _$QuotaFailureImpl value, $Res Function(_$QuotaFailureImpl) then) =
      __$$QuotaFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$QuotaFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$QuotaFailureImpl>
    implements _$$QuotaFailureImplCopyWith<$Res> {
  __$$QuotaFailureImplCopyWithImpl(
      _$QuotaFailureImpl _value, $Res Function(_$QuotaFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$QuotaFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$QuotaFailureImpl implements QuotaFailure {
  const _$QuotaFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.quota(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuotaFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuotaFailureImplCopyWith<_$QuotaFailureImpl> get copyWith =>
      __$$QuotaFailureImplCopyWithImpl<_$QuotaFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message) permission,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message) conflict,
    required TResult Function(String message) storage,
    required TResult Function(String message) quota,
    required TResult Function(String message) ai,
    required TResult Function(String message) configuration,
    required TResult Function(String message) unknown,
  }) {
    return quota(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message)? permission,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message)? conflict,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? quota,
    TResult? Function(String message)? ai,
    TResult? Function(String message)? configuration,
    TResult? Function(String message)? unknown,
  }) {
    return quota?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message)? permission,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message)? conflict,
    TResult Function(String message)? storage,
    TResult Function(String message)? quota,
    TResult Function(String message)? ai,
    TResult Function(String message)? configuration,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (quota != null) {
      return quota(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(ConflictFailure value) conflict,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(QuotaFailure value) quota,
    required TResult Function(AiFailure value) ai,
    required TResult Function(ConfigurationFailure value) configuration,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return quota(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(ConflictFailure value)? conflict,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(QuotaFailure value)? quota,
    TResult? Function(AiFailure value)? ai,
    TResult? Function(ConfigurationFailure value)? configuration,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return quota?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(ConflictFailure value)? conflict,
    TResult Function(StorageFailure value)? storage,
    TResult Function(QuotaFailure value)? quota,
    TResult Function(AiFailure value)? ai,
    TResult Function(ConfigurationFailure value)? configuration,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (quota != null) {
      return quota(this);
    }
    return orElse();
  }
}

abstract class QuotaFailure implements Failure {
  const factory QuotaFailure({required final String message}) =
      _$QuotaFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuotaFailureImplCopyWith<_$QuotaFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AiFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$AiFailureImplCopyWith(
          _$AiFailureImpl value, $Res Function(_$AiFailureImpl) then) =
      __$$AiFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AiFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$AiFailureImpl>
    implements _$$AiFailureImplCopyWith<$Res> {
  __$$AiFailureImplCopyWithImpl(
      _$AiFailureImpl _value, $Res Function(_$AiFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$AiFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AiFailureImpl implements AiFailure {
  const _$AiFailureImpl({this.message = 'AI is unavailable right now.'});

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'Failure.ai(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiFailureImplCopyWith<_$AiFailureImpl> get copyWith =>
      __$$AiFailureImplCopyWithImpl<_$AiFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message) permission,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message) conflict,
    required TResult Function(String message) storage,
    required TResult Function(String message) quota,
    required TResult Function(String message) ai,
    required TResult Function(String message) configuration,
    required TResult Function(String message) unknown,
  }) {
    return ai(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message)? permission,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message)? conflict,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? quota,
    TResult? Function(String message)? ai,
    TResult? Function(String message)? configuration,
    TResult? Function(String message)? unknown,
  }) {
    return ai?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message)? permission,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message)? conflict,
    TResult Function(String message)? storage,
    TResult Function(String message)? quota,
    TResult Function(String message)? ai,
    TResult Function(String message)? configuration,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (ai != null) {
      return ai(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(ConflictFailure value) conflict,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(QuotaFailure value) quota,
    required TResult Function(AiFailure value) ai,
    required TResult Function(ConfigurationFailure value) configuration,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return ai(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(ConflictFailure value)? conflict,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(QuotaFailure value)? quota,
    TResult? Function(AiFailure value)? ai,
    TResult? Function(ConfigurationFailure value)? configuration,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return ai?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(ConflictFailure value)? conflict,
    TResult Function(StorageFailure value)? storage,
    TResult Function(QuotaFailure value)? quota,
    TResult Function(AiFailure value)? ai,
    TResult Function(ConfigurationFailure value)? configuration,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (ai != null) {
      return ai(this);
    }
    return orElse();
  }
}

abstract class AiFailure implements Failure {
  const factory AiFailure({final String message}) = _$AiFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiFailureImplCopyWith<_$AiFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConfigurationFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$ConfigurationFailureImplCopyWith(_$ConfigurationFailureImpl value,
          $Res Function(_$ConfigurationFailureImpl) then) =
      __$$ConfigurationFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ConfigurationFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ConfigurationFailureImpl>
    implements _$$ConfigurationFailureImplCopyWith<$Res> {
  __$$ConfigurationFailureImplCopyWithImpl(_$ConfigurationFailureImpl _value,
      $Res Function(_$ConfigurationFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ConfigurationFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ConfigurationFailureImpl implements ConfigurationFailure {
  const _$ConfigurationFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.configuration(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfigurationFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfigurationFailureImplCopyWith<_$ConfigurationFailureImpl>
      get copyWith =>
          __$$ConfigurationFailureImplCopyWithImpl<_$ConfigurationFailureImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message) permission,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message) conflict,
    required TResult Function(String message) storage,
    required TResult Function(String message) quota,
    required TResult Function(String message) ai,
    required TResult Function(String message) configuration,
    required TResult Function(String message) unknown,
  }) {
    return configuration(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message)? permission,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message)? conflict,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? quota,
    TResult? Function(String message)? ai,
    TResult? Function(String message)? configuration,
    TResult? Function(String message)? unknown,
  }) {
    return configuration?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message)? permission,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message)? conflict,
    TResult Function(String message)? storage,
    TResult Function(String message)? quota,
    TResult Function(String message)? ai,
    TResult Function(String message)? configuration,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (configuration != null) {
      return configuration(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(ConflictFailure value) conflict,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(QuotaFailure value) quota,
    required TResult Function(AiFailure value) ai,
    required TResult Function(ConfigurationFailure value) configuration,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return configuration(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(ConflictFailure value)? conflict,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(QuotaFailure value)? quota,
    TResult? Function(AiFailure value)? ai,
    TResult? Function(ConfigurationFailure value)? configuration,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return configuration?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(ConflictFailure value)? conflict,
    TResult Function(StorageFailure value)? storage,
    TResult Function(QuotaFailure value)? quota,
    TResult Function(AiFailure value)? ai,
    TResult Function(ConfigurationFailure value)? configuration,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (configuration != null) {
      return configuration(this);
    }
    return orElse();
  }
}

abstract class ConfigurationFailure implements Failure {
  const factory ConfigurationFailure({required final String message}) =
      _$ConfigurationFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfigurationFailureImplCopyWith<_$ConfigurationFailureImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$UnknownFailureImplCopyWith(_$UnknownFailureImpl value,
          $Res Function(_$UnknownFailureImpl) then) =
      __$$UnknownFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UnknownFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnknownFailureImpl>
    implements _$$UnknownFailureImplCopyWith<$Res> {
  __$$UnknownFailureImplCopyWithImpl(
      _$UnknownFailureImpl _value, $Res Function(_$UnknownFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$UnknownFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UnknownFailureImpl implements UnknownFailure {
  const _$UnknownFailureImpl(
      {this.message = 'Something went wrong. Please try again.'});

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'Failure.unknown(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      __$$UnknownFailureImplCopyWithImpl<_$UnknownFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message) permission,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message) conflict,
    required TResult Function(String message) storage,
    required TResult Function(String message) quota,
    required TResult Function(String message) ai,
    required TResult Function(String message) configuration,
    required TResult Function(String message) unknown,
  }) {
    return unknown(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message)? permission,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message)? conflict,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? quota,
    TResult? Function(String message)? ai,
    TResult? Function(String message)? configuration,
    TResult? Function(String message)? unknown,
  }) {
    return unknown?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message)? permission,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message)? conflict,
    TResult Function(String message)? storage,
    TResult Function(String message)? quota,
    TResult Function(String message)? ai,
    TResult Function(String message)? configuration,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(ConflictFailure value) conflict,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(QuotaFailure value) quota,
    required TResult Function(AiFailure value) ai,
    required TResult Function(ConfigurationFailure value) configuration,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(ConflictFailure value)? conflict,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(QuotaFailure value)? quota,
    TResult? Function(AiFailure value)? ai,
    TResult? Function(ConfigurationFailure value)? configuration,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(ConflictFailure value)? conflict,
    TResult Function(StorageFailure value)? storage,
    TResult Function(QuotaFailure value)? quota,
    TResult Function(AiFailure value)? ai,
    TResult Function(ConfigurationFailure value)? configuration,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownFailure implements Failure {
  const factory UnknownFailure({final String message}) = _$UnknownFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
