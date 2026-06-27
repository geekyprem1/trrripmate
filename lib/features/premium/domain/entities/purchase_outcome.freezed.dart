// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_outcome.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PurchaseOutcome {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? productId, String? purchaseToken) success,
    required TResult Function() cancelled,
    required TResult Function() pending,
    required TResult Function() nothingToRestore,
    required TResult Function(String message) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? productId, String? purchaseToken)? success,
    TResult? Function()? cancelled,
    TResult? Function()? pending,
    TResult? Function()? nothingToRestore,
    TResult? Function(String message)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? productId, String? purchaseToken)? success,
    TResult Function()? cancelled,
    TResult Function()? pending,
    TResult Function()? nothingToRestore,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PurchaseSuccess value) success,
    required TResult Function(PurchaseCancelled value) cancelled,
    required TResult Function(PurchasePending value) pending,
    required TResult Function(PurchaseNothingToRestore value) nothingToRestore,
    required TResult Function(PurchaseFailed value) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PurchaseSuccess value)? success,
    TResult? Function(PurchaseCancelled value)? cancelled,
    TResult? Function(PurchasePending value)? pending,
    TResult? Function(PurchaseNothingToRestore value)? nothingToRestore,
    TResult? Function(PurchaseFailed value)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PurchaseSuccess value)? success,
    TResult Function(PurchaseCancelled value)? cancelled,
    TResult Function(PurchasePending value)? pending,
    TResult Function(PurchaseNothingToRestore value)? nothingToRestore,
    TResult Function(PurchaseFailed value)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseOutcomeCopyWith<$Res> {
  factory $PurchaseOutcomeCopyWith(
          PurchaseOutcome value, $Res Function(PurchaseOutcome) then) =
      _$PurchaseOutcomeCopyWithImpl<$Res, PurchaseOutcome>;
}

/// @nodoc
class _$PurchaseOutcomeCopyWithImpl<$Res, $Val extends PurchaseOutcome>
    implements $PurchaseOutcomeCopyWith<$Res> {
  _$PurchaseOutcomeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseOutcome
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PurchaseSuccessImplCopyWith<$Res> {
  factory _$$PurchaseSuccessImplCopyWith(_$PurchaseSuccessImpl value,
          $Res Function(_$PurchaseSuccessImpl) then) =
      __$$PurchaseSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? productId, String? purchaseToken});
}

/// @nodoc
class __$$PurchaseSuccessImplCopyWithImpl<$Res>
    extends _$PurchaseOutcomeCopyWithImpl<$Res, _$PurchaseSuccessImpl>
    implements _$$PurchaseSuccessImplCopyWith<$Res> {
  __$$PurchaseSuccessImplCopyWithImpl(
      _$PurchaseSuccessImpl _value, $Res Function(_$PurchaseSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of PurchaseOutcome
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? purchaseToken = freezed,
  }) {
    return _then(_$PurchaseSuccessImpl(
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseToken: freezed == purchaseToken
          ? _value.purchaseToken
          : purchaseToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PurchaseSuccessImpl implements PurchaseSuccess {
  const _$PurchaseSuccessImpl({this.productId, this.purchaseToken});

  @override
  final String? productId;
  @override
  final String? purchaseToken;

  @override
  String toString() {
    return 'PurchaseOutcome.success(productId: $productId, purchaseToken: $purchaseToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseSuccessImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.purchaseToken, purchaseToken) ||
                other.purchaseToken == purchaseToken));
  }

  @override
  int get hashCode => Object.hash(runtimeType, productId, purchaseToken);

  /// Create a copy of PurchaseOutcome
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseSuccessImplCopyWith<_$PurchaseSuccessImpl> get copyWith =>
      __$$PurchaseSuccessImplCopyWithImpl<_$PurchaseSuccessImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? productId, String? purchaseToken) success,
    required TResult Function() cancelled,
    required TResult Function() pending,
    required TResult Function() nothingToRestore,
    required TResult Function(String message) failed,
  }) {
    return success(productId, purchaseToken);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? productId, String? purchaseToken)? success,
    TResult? Function()? cancelled,
    TResult? Function()? pending,
    TResult? Function()? nothingToRestore,
    TResult? Function(String message)? failed,
  }) {
    return success?.call(productId, purchaseToken);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? productId, String? purchaseToken)? success,
    TResult Function()? cancelled,
    TResult Function()? pending,
    TResult Function()? nothingToRestore,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(productId, purchaseToken);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PurchaseSuccess value) success,
    required TResult Function(PurchaseCancelled value) cancelled,
    required TResult Function(PurchasePending value) pending,
    required TResult Function(PurchaseNothingToRestore value) nothingToRestore,
    required TResult Function(PurchaseFailed value) failed,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PurchaseSuccess value)? success,
    TResult? Function(PurchaseCancelled value)? cancelled,
    TResult? Function(PurchasePending value)? pending,
    TResult? Function(PurchaseNothingToRestore value)? nothingToRestore,
    TResult? Function(PurchaseFailed value)? failed,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PurchaseSuccess value)? success,
    TResult Function(PurchaseCancelled value)? cancelled,
    TResult Function(PurchasePending value)? pending,
    TResult Function(PurchaseNothingToRestore value)? nothingToRestore,
    TResult Function(PurchaseFailed value)? failed,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class PurchaseSuccess implements PurchaseOutcome {
  const factory PurchaseSuccess(
      {final String? productId,
      final String? purchaseToken}) = _$PurchaseSuccessImpl;

  String? get productId;
  String? get purchaseToken;

  /// Create a copy of PurchaseOutcome
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseSuccessImplCopyWith<_$PurchaseSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PurchaseCancelledImplCopyWith<$Res> {
  factory _$$PurchaseCancelledImplCopyWith(_$PurchaseCancelledImpl value,
          $Res Function(_$PurchaseCancelledImpl) then) =
      __$$PurchaseCancelledImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PurchaseCancelledImplCopyWithImpl<$Res>
    extends _$PurchaseOutcomeCopyWithImpl<$Res, _$PurchaseCancelledImpl>
    implements _$$PurchaseCancelledImplCopyWith<$Res> {
  __$$PurchaseCancelledImplCopyWithImpl(_$PurchaseCancelledImpl _value,
      $Res Function(_$PurchaseCancelledImpl) _then)
      : super(_value, _then);

  /// Create a copy of PurchaseOutcome
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PurchaseCancelledImpl implements PurchaseCancelled {
  const _$PurchaseCancelledImpl();

  @override
  String toString() {
    return 'PurchaseOutcome.cancelled()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PurchaseCancelledImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? productId, String? purchaseToken) success,
    required TResult Function() cancelled,
    required TResult Function() pending,
    required TResult Function() nothingToRestore,
    required TResult Function(String message) failed,
  }) {
    return cancelled();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? productId, String? purchaseToken)? success,
    TResult? Function()? cancelled,
    TResult? Function()? pending,
    TResult? Function()? nothingToRestore,
    TResult? Function(String message)? failed,
  }) {
    return cancelled?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? productId, String? purchaseToken)? success,
    TResult Function()? cancelled,
    TResult Function()? pending,
    TResult Function()? nothingToRestore,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PurchaseSuccess value) success,
    required TResult Function(PurchaseCancelled value) cancelled,
    required TResult Function(PurchasePending value) pending,
    required TResult Function(PurchaseNothingToRestore value) nothingToRestore,
    required TResult Function(PurchaseFailed value) failed,
  }) {
    return cancelled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PurchaseSuccess value)? success,
    TResult? Function(PurchaseCancelled value)? cancelled,
    TResult? Function(PurchasePending value)? pending,
    TResult? Function(PurchaseNothingToRestore value)? nothingToRestore,
    TResult? Function(PurchaseFailed value)? failed,
  }) {
    return cancelled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PurchaseSuccess value)? success,
    TResult Function(PurchaseCancelled value)? cancelled,
    TResult Function(PurchasePending value)? pending,
    TResult Function(PurchaseNothingToRestore value)? nothingToRestore,
    TResult Function(PurchaseFailed value)? failed,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled(this);
    }
    return orElse();
  }
}

abstract class PurchaseCancelled implements PurchaseOutcome {
  const factory PurchaseCancelled() = _$PurchaseCancelledImpl;
}

/// @nodoc
abstract class _$$PurchasePendingImplCopyWith<$Res> {
  factory _$$PurchasePendingImplCopyWith(_$PurchasePendingImpl value,
          $Res Function(_$PurchasePendingImpl) then) =
      __$$PurchasePendingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PurchasePendingImplCopyWithImpl<$Res>
    extends _$PurchaseOutcomeCopyWithImpl<$Res, _$PurchasePendingImpl>
    implements _$$PurchasePendingImplCopyWith<$Res> {
  __$$PurchasePendingImplCopyWithImpl(
      _$PurchasePendingImpl _value, $Res Function(_$PurchasePendingImpl) _then)
      : super(_value, _then);

  /// Create a copy of PurchaseOutcome
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PurchasePendingImpl implements PurchasePending {
  const _$PurchasePendingImpl();

  @override
  String toString() {
    return 'PurchaseOutcome.pending()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PurchasePendingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? productId, String? purchaseToken) success,
    required TResult Function() cancelled,
    required TResult Function() pending,
    required TResult Function() nothingToRestore,
    required TResult Function(String message) failed,
  }) {
    return pending();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? productId, String? purchaseToken)? success,
    TResult? Function()? cancelled,
    TResult? Function()? pending,
    TResult? Function()? nothingToRestore,
    TResult? Function(String message)? failed,
  }) {
    return pending?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? productId, String? purchaseToken)? success,
    TResult Function()? cancelled,
    TResult Function()? pending,
    TResult Function()? nothingToRestore,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (pending != null) {
      return pending();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PurchaseSuccess value) success,
    required TResult Function(PurchaseCancelled value) cancelled,
    required TResult Function(PurchasePending value) pending,
    required TResult Function(PurchaseNothingToRestore value) nothingToRestore,
    required TResult Function(PurchaseFailed value) failed,
  }) {
    return pending(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PurchaseSuccess value)? success,
    TResult? Function(PurchaseCancelled value)? cancelled,
    TResult? Function(PurchasePending value)? pending,
    TResult? Function(PurchaseNothingToRestore value)? nothingToRestore,
    TResult? Function(PurchaseFailed value)? failed,
  }) {
    return pending?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PurchaseSuccess value)? success,
    TResult Function(PurchaseCancelled value)? cancelled,
    TResult Function(PurchasePending value)? pending,
    TResult Function(PurchaseNothingToRestore value)? nothingToRestore,
    TResult Function(PurchaseFailed value)? failed,
    required TResult orElse(),
  }) {
    if (pending != null) {
      return pending(this);
    }
    return orElse();
  }
}

abstract class PurchasePending implements PurchaseOutcome {
  const factory PurchasePending() = _$PurchasePendingImpl;
}

/// @nodoc
abstract class _$$PurchaseNothingToRestoreImplCopyWith<$Res> {
  factory _$$PurchaseNothingToRestoreImplCopyWith(
          _$PurchaseNothingToRestoreImpl value,
          $Res Function(_$PurchaseNothingToRestoreImpl) then) =
      __$$PurchaseNothingToRestoreImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PurchaseNothingToRestoreImplCopyWithImpl<$Res>
    extends _$PurchaseOutcomeCopyWithImpl<$Res, _$PurchaseNothingToRestoreImpl>
    implements _$$PurchaseNothingToRestoreImplCopyWith<$Res> {
  __$$PurchaseNothingToRestoreImplCopyWithImpl(
      _$PurchaseNothingToRestoreImpl _value,
      $Res Function(_$PurchaseNothingToRestoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of PurchaseOutcome
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PurchaseNothingToRestoreImpl implements PurchaseNothingToRestore {
  const _$PurchaseNothingToRestoreImpl();

  @override
  String toString() {
    return 'PurchaseOutcome.nothingToRestore()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseNothingToRestoreImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? productId, String? purchaseToken) success,
    required TResult Function() cancelled,
    required TResult Function() pending,
    required TResult Function() nothingToRestore,
    required TResult Function(String message) failed,
  }) {
    return nothingToRestore();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? productId, String? purchaseToken)? success,
    TResult? Function()? cancelled,
    TResult? Function()? pending,
    TResult? Function()? nothingToRestore,
    TResult? Function(String message)? failed,
  }) {
    return nothingToRestore?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? productId, String? purchaseToken)? success,
    TResult Function()? cancelled,
    TResult Function()? pending,
    TResult Function()? nothingToRestore,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (nothingToRestore != null) {
      return nothingToRestore();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PurchaseSuccess value) success,
    required TResult Function(PurchaseCancelled value) cancelled,
    required TResult Function(PurchasePending value) pending,
    required TResult Function(PurchaseNothingToRestore value) nothingToRestore,
    required TResult Function(PurchaseFailed value) failed,
  }) {
    return nothingToRestore(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PurchaseSuccess value)? success,
    TResult? Function(PurchaseCancelled value)? cancelled,
    TResult? Function(PurchasePending value)? pending,
    TResult? Function(PurchaseNothingToRestore value)? nothingToRestore,
    TResult? Function(PurchaseFailed value)? failed,
  }) {
    return nothingToRestore?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PurchaseSuccess value)? success,
    TResult Function(PurchaseCancelled value)? cancelled,
    TResult Function(PurchasePending value)? pending,
    TResult Function(PurchaseNothingToRestore value)? nothingToRestore,
    TResult Function(PurchaseFailed value)? failed,
    required TResult orElse(),
  }) {
    if (nothingToRestore != null) {
      return nothingToRestore(this);
    }
    return orElse();
  }
}

abstract class PurchaseNothingToRestore implements PurchaseOutcome {
  const factory PurchaseNothingToRestore() = _$PurchaseNothingToRestoreImpl;
}

/// @nodoc
abstract class _$$PurchaseFailedImplCopyWith<$Res> {
  factory _$$PurchaseFailedImplCopyWith(_$PurchaseFailedImpl value,
          $Res Function(_$PurchaseFailedImpl) then) =
      __$$PurchaseFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PurchaseFailedImplCopyWithImpl<$Res>
    extends _$PurchaseOutcomeCopyWithImpl<$Res, _$PurchaseFailedImpl>
    implements _$$PurchaseFailedImplCopyWith<$Res> {
  __$$PurchaseFailedImplCopyWithImpl(
      _$PurchaseFailedImpl _value, $Res Function(_$PurchaseFailedImpl) _then)
      : super(_value, _then);

  /// Create a copy of PurchaseOutcome
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$PurchaseFailedImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PurchaseFailedImpl implements PurchaseFailed {
  const _$PurchaseFailedImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'PurchaseOutcome.failed(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseFailedImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of PurchaseOutcome
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseFailedImplCopyWith<_$PurchaseFailedImpl> get copyWith =>
      __$$PurchaseFailedImplCopyWithImpl<_$PurchaseFailedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? productId, String? purchaseToken) success,
    required TResult Function() cancelled,
    required TResult Function() pending,
    required TResult Function() nothingToRestore,
    required TResult Function(String message) failed,
  }) {
    return failed(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? productId, String? purchaseToken)? success,
    TResult? Function()? cancelled,
    TResult? Function()? pending,
    TResult? Function()? nothingToRestore,
    TResult? Function(String message)? failed,
  }) {
    return failed?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? productId, String? purchaseToken)? success,
    TResult Function()? cancelled,
    TResult Function()? pending,
    TResult Function()? nothingToRestore,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PurchaseSuccess value) success,
    required TResult Function(PurchaseCancelled value) cancelled,
    required TResult Function(PurchasePending value) pending,
    required TResult Function(PurchaseNothingToRestore value) nothingToRestore,
    required TResult Function(PurchaseFailed value) failed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PurchaseSuccess value)? success,
    TResult? Function(PurchaseCancelled value)? cancelled,
    TResult? Function(PurchasePending value)? pending,
    TResult? Function(PurchaseNothingToRestore value)? nothingToRestore,
    TResult? Function(PurchaseFailed value)? failed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PurchaseSuccess value)? success,
    TResult Function(PurchaseCancelled value)? cancelled,
    TResult Function(PurchasePending value)? pending,
    TResult Function(PurchaseNothingToRestore value)? nothingToRestore,
    TResult Function(PurchaseFailed value)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class PurchaseFailed implements PurchaseOutcome {
  const factory PurchaseFailed(final String message) = _$PurchaseFailedImpl;

  String get message;

  /// Create a copy of PurchaseOutcome
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseFailedImplCopyWith<_$PurchaseFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
