// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ReportFilter {
  DateTime? get start => throw _privateConstructorUsedError;
  DateTime? get end => throw _privateConstructorUsedError;
  String? get memberId => throw _privateConstructorUsedError;
  ExpenseCategory? get category => throw _privateConstructorUsedError;

  /// Create a copy of ReportFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportFilterCopyWith<ReportFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportFilterCopyWith<$Res> {
  factory $ReportFilterCopyWith(
          ReportFilter value, $Res Function(ReportFilter) then) =
      _$ReportFilterCopyWithImpl<$Res, ReportFilter>;
  @useResult
  $Res call(
      {DateTime? start,
      DateTime? end,
      String? memberId,
      ExpenseCategory? category});
}

/// @nodoc
class _$ReportFilterCopyWithImpl<$Res, $Val extends ReportFilter>
    implements $ReportFilterCopyWith<$Res> {
  _$ReportFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = freezed,
    Object? end = freezed,
    Object? memberId = freezed,
    Object? category = freezed,
  }) {
    return _then(_value.copyWith(
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memberId: freezed == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ExpenseCategory?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportFilterImplCopyWith<$Res>
    implements $ReportFilterCopyWith<$Res> {
  factory _$$ReportFilterImplCopyWith(
          _$ReportFilterImpl value, $Res Function(_$ReportFilterImpl) then) =
      __$$ReportFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime? start,
      DateTime? end,
      String? memberId,
      ExpenseCategory? category});
}

/// @nodoc
class __$$ReportFilterImplCopyWithImpl<$Res>
    extends _$ReportFilterCopyWithImpl<$Res, _$ReportFilterImpl>
    implements _$$ReportFilterImplCopyWith<$Res> {
  __$$ReportFilterImplCopyWithImpl(
      _$ReportFilterImpl _value, $Res Function(_$ReportFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReportFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = freezed,
    Object? end = freezed,
    Object? memberId = freezed,
    Object? category = freezed,
  }) {
    return _then(_$ReportFilterImpl(
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memberId: freezed == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ExpenseCategory?,
    ));
  }
}

/// @nodoc

class _$ReportFilterImpl extends _ReportFilter {
  const _$ReportFilterImpl({this.start, this.end, this.memberId, this.category})
      : super._();

  @override
  final DateTime? start;
  @override
  final DateTime? end;
  @override
  final String? memberId;
  @override
  final ExpenseCategory? category;

  @override
  String toString() {
    return 'ReportFilter(start: $start, end: $end, memberId: $memberId, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportFilterImpl &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, start, end, memberId, category);

  /// Create a copy of ReportFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportFilterImplCopyWith<_$ReportFilterImpl> get copyWith =>
      __$$ReportFilterImplCopyWithImpl<_$ReportFilterImpl>(this, _$identity);
}

abstract class _ReportFilter extends ReportFilter {
  const factory _ReportFilter(
      {final DateTime? start,
      final DateTime? end,
      final String? memberId,
      final ExpenseCategory? category}) = _$ReportFilterImpl;
  const _ReportFilter._() : super._();

  @override
  DateTime? get start;
  @override
  DateTime? get end;
  @override
  String? get memberId;
  @override
  ExpenseCategory? get category;

  /// Create a copy of ReportFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportFilterImplCopyWith<_$ReportFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
