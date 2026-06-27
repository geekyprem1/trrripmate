// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MemberBalance {
  String get memberId => throw _privateConstructorUsedError;
  int get netMinor => throw _privateConstructorUsedError;

  /// Create a copy of MemberBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberBalanceCopyWith<MemberBalance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberBalanceCopyWith<$Res> {
  factory $MemberBalanceCopyWith(
          MemberBalance value, $Res Function(MemberBalance) then) =
      _$MemberBalanceCopyWithImpl<$Res, MemberBalance>;
  @useResult
  $Res call({String memberId, int netMinor});
}

/// @nodoc
class _$MemberBalanceCopyWithImpl<$Res, $Val extends MemberBalance>
    implements $MemberBalanceCopyWith<$Res> {
  _$MemberBalanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? netMinor = null,
  }) {
    return _then(_value.copyWith(
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      netMinor: null == netMinor
          ? _value.netMinor
          : netMinor // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemberBalanceImplCopyWith<$Res>
    implements $MemberBalanceCopyWith<$Res> {
  factory _$$MemberBalanceImplCopyWith(
          _$MemberBalanceImpl value, $Res Function(_$MemberBalanceImpl) then) =
      __$$MemberBalanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String memberId, int netMinor});
}

/// @nodoc
class __$$MemberBalanceImplCopyWithImpl<$Res>
    extends _$MemberBalanceCopyWithImpl<$Res, _$MemberBalanceImpl>
    implements _$$MemberBalanceImplCopyWith<$Res> {
  __$$MemberBalanceImplCopyWithImpl(
      _$MemberBalanceImpl _value, $Res Function(_$MemberBalanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of MemberBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? netMinor = null,
  }) {
    return _then(_$MemberBalanceImpl(
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      netMinor: null == netMinor
          ? _value.netMinor
          : netMinor // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$MemberBalanceImpl extends _MemberBalance {
  const _$MemberBalanceImpl({required this.memberId, required this.netMinor})
      : super._();

  @override
  final String memberId;
  @override
  final int netMinor;

  @override
  String toString() {
    return 'MemberBalance(memberId: $memberId, netMinor: $netMinor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberBalanceImpl &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.netMinor, netMinor) ||
                other.netMinor == netMinor));
  }

  @override
  int get hashCode => Object.hash(runtimeType, memberId, netMinor);

  /// Create a copy of MemberBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberBalanceImplCopyWith<_$MemberBalanceImpl> get copyWith =>
      __$$MemberBalanceImplCopyWithImpl<_$MemberBalanceImpl>(this, _$identity);
}

abstract class _MemberBalance extends MemberBalance {
  const factory _MemberBalance(
      {required final String memberId,
      required final int netMinor}) = _$MemberBalanceImpl;
  const _MemberBalance._() : super._();

  @override
  String get memberId;
  @override
  int get netMinor;

  /// Create a copy of MemberBalance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberBalanceImplCopyWith<_$MemberBalanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
