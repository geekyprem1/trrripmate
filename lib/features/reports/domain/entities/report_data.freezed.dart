// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CategorySlice {
  ExpenseCategory get category => throw _privateConstructorUsedError;
  int get amountMinor => throw _privateConstructorUsedError;
  double get fraction => throw _privateConstructorUsedError;

  /// Create a copy of CategorySlice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategorySliceCopyWith<CategorySlice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategorySliceCopyWith<$Res> {
  factory $CategorySliceCopyWith(
          CategorySlice value, $Res Function(CategorySlice) then) =
      _$CategorySliceCopyWithImpl<$Res, CategorySlice>;
  @useResult
  $Res call({ExpenseCategory category, int amountMinor, double fraction});
}

/// @nodoc
class _$CategorySliceCopyWithImpl<$Res, $Val extends CategorySlice>
    implements $CategorySliceCopyWith<$Res> {
  _$CategorySliceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategorySlice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? amountMinor = null,
    Object? fraction = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ExpenseCategory,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      fraction: null == fraction
          ? _value.fraction
          : fraction // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategorySliceImplCopyWith<$Res>
    implements $CategorySliceCopyWith<$Res> {
  factory _$$CategorySliceImplCopyWith(
          _$CategorySliceImpl value, $Res Function(_$CategorySliceImpl) then) =
      __$$CategorySliceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ExpenseCategory category, int amountMinor, double fraction});
}

/// @nodoc
class __$$CategorySliceImplCopyWithImpl<$Res>
    extends _$CategorySliceCopyWithImpl<$Res, _$CategorySliceImpl>
    implements _$$CategorySliceImplCopyWith<$Res> {
  __$$CategorySliceImplCopyWithImpl(
      _$CategorySliceImpl _value, $Res Function(_$CategorySliceImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategorySlice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? amountMinor = null,
    Object? fraction = null,
  }) {
    return _then(_$CategorySliceImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ExpenseCategory,
      amountMinor: null == amountMinor
          ? _value.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      fraction: null == fraction
          ? _value.fraction
          : fraction // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$CategorySliceImpl implements _CategorySlice {
  const _$CategorySliceImpl(
      {required this.category,
      required this.amountMinor,
      required this.fraction});

  @override
  final ExpenseCategory category;
  @override
  final int amountMinor;
  @override
  final double fraction;

  @override
  String toString() {
    return 'CategorySlice(category: $category, amountMinor: $amountMinor, fraction: $fraction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategorySliceImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.fraction, fraction) ||
                other.fraction == fraction));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category, amountMinor, fraction);

  /// Create a copy of CategorySlice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategorySliceImplCopyWith<_$CategorySliceImpl> get copyWith =>
      __$$CategorySliceImplCopyWithImpl<_$CategorySliceImpl>(this, _$identity);
}

abstract class _CategorySlice implements CategorySlice {
  const factory _CategorySlice(
      {required final ExpenseCategory category,
      required final int amountMinor,
      required final double fraction}) = _$CategorySliceImpl;

  @override
  ExpenseCategory get category;
  @override
  int get amountMinor;
  @override
  double get fraction;

  /// Create a copy of CategorySlice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategorySliceImplCopyWith<_$CategorySliceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MemberSpend {
  String get memberId => throw _privateConstructorUsedError;
  String get memberName => throw _privateConstructorUsedError;
  int get paidMinor => throw _privateConstructorUsedError;
  int get owedMinor => throw _privateConstructorUsedError;

  /// Create a copy of MemberSpend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberSpendCopyWith<MemberSpend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberSpendCopyWith<$Res> {
  factory $MemberSpendCopyWith(
          MemberSpend value, $Res Function(MemberSpend) then) =
      _$MemberSpendCopyWithImpl<$Res, MemberSpend>;
  @useResult
  $Res call({String memberId, String memberName, int paidMinor, int owedMinor});
}

/// @nodoc
class _$MemberSpendCopyWithImpl<$Res, $Val extends MemberSpend>
    implements $MemberSpendCopyWith<$Res> {
  _$MemberSpendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberSpend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? memberName = null,
    Object? paidMinor = null,
    Object? owedMinor = null,
  }) {
    return _then(_value.copyWith(
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      paidMinor: null == paidMinor
          ? _value.paidMinor
          : paidMinor // ignore: cast_nullable_to_non_nullable
              as int,
      owedMinor: null == owedMinor
          ? _value.owedMinor
          : owedMinor // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemberSpendImplCopyWith<$Res>
    implements $MemberSpendCopyWith<$Res> {
  factory _$$MemberSpendImplCopyWith(
          _$MemberSpendImpl value, $Res Function(_$MemberSpendImpl) then) =
      __$$MemberSpendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String memberId, String memberName, int paidMinor, int owedMinor});
}

/// @nodoc
class __$$MemberSpendImplCopyWithImpl<$Res>
    extends _$MemberSpendCopyWithImpl<$Res, _$MemberSpendImpl>
    implements _$$MemberSpendImplCopyWith<$Res> {
  __$$MemberSpendImplCopyWithImpl(
      _$MemberSpendImpl _value, $Res Function(_$MemberSpendImpl) _then)
      : super(_value, _then);

  /// Create a copy of MemberSpend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? memberName = null,
    Object? paidMinor = null,
    Object? owedMinor = null,
  }) {
    return _then(_$MemberSpendImpl(
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      paidMinor: null == paidMinor
          ? _value.paidMinor
          : paidMinor // ignore: cast_nullable_to_non_nullable
              as int,
      owedMinor: null == owedMinor
          ? _value.owedMinor
          : owedMinor // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$MemberSpendImpl implements _MemberSpend {
  const _$MemberSpendImpl(
      {required this.memberId,
      required this.memberName,
      required this.paidMinor,
      required this.owedMinor});

  @override
  final String memberId;
  @override
  final String memberName;
  @override
  final int paidMinor;
  @override
  final int owedMinor;

  @override
  String toString() {
    return 'MemberSpend(memberId: $memberId, memberName: $memberName, paidMinor: $paidMinor, owedMinor: $owedMinor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberSpendImpl &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName) &&
            (identical(other.paidMinor, paidMinor) ||
                other.paidMinor == paidMinor) &&
            (identical(other.owedMinor, owedMinor) ||
                other.owedMinor == owedMinor));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, memberId, memberName, paidMinor, owedMinor);

  /// Create a copy of MemberSpend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberSpendImplCopyWith<_$MemberSpendImpl> get copyWith =>
      __$$MemberSpendImplCopyWithImpl<_$MemberSpendImpl>(this, _$identity);
}

abstract class _MemberSpend implements MemberSpend {
  const factory _MemberSpend(
      {required final String memberId,
      required final String memberName,
      required final int paidMinor,
      required final int owedMinor}) = _$MemberSpendImpl;

  @override
  String get memberId;
  @override
  String get memberName;
  @override
  int get paidMinor;
  @override
  int get owedMinor;

  /// Create a copy of MemberSpend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberSpendImplCopyWith<_$MemberSpendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TimelinePoint {
  DateTime get date => throw _privateConstructorUsedError;
  int get dailyMinor => throw _privateConstructorUsedError;
  int get cumulativeMinor => throw _privateConstructorUsedError;

  /// Create a copy of TimelinePoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimelinePointCopyWith<TimelinePoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelinePointCopyWith<$Res> {
  factory $TimelinePointCopyWith(
          TimelinePoint value, $Res Function(TimelinePoint) then) =
      _$TimelinePointCopyWithImpl<$Res, TimelinePoint>;
  @useResult
  $Res call({DateTime date, int dailyMinor, int cumulativeMinor});
}

/// @nodoc
class _$TimelinePointCopyWithImpl<$Res, $Val extends TimelinePoint>
    implements $TimelinePointCopyWith<$Res> {
  _$TimelinePointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimelinePoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? dailyMinor = null,
    Object? cumulativeMinor = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dailyMinor: null == dailyMinor
          ? _value.dailyMinor
          : dailyMinor // ignore: cast_nullable_to_non_nullable
              as int,
      cumulativeMinor: null == cumulativeMinor
          ? _value.cumulativeMinor
          : cumulativeMinor // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimelinePointImplCopyWith<$Res>
    implements $TimelinePointCopyWith<$Res> {
  factory _$$TimelinePointImplCopyWith(
          _$TimelinePointImpl value, $Res Function(_$TimelinePointImpl) then) =
      __$$TimelinePointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, int dailyMinor, int cumulativeMinor});
}

/// @nodoc
class __$$TimelinePointImplCopyWithImpl<$Res>
    extends _$TimelinePointCopyWithImpl<$Res, _$TimelinePointImpl>
    implements _$$TimelinePointImplCopyWith<$Res> {
  __$$TimelinePointImplCopyWithImpl(
      _$TimelinePointImpl _value, $Res Function(_$TimelinePointImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimelinePoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? dailyMinor = null,
    Object? cumulativeMinor = null,
  }) {
    return _then(_$TimelinePointImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dailyMinor: null == dailyMinor
          ? _value.dailyMinor
          : dailyMinor // ignore: cast_nullable_to_non_nullable
              as int,
      cumulativeMinor: null == cumulativeMinor
          ? _value.cumulativeMinor
          : cumulativeMinor // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TimelinePointImpl implements _TimelinePoint {
  const _$TimelinePointImpl(
      {required this.date,
      required this.dailyMinor,
      required this.cumulativeMinor});

  @override
  final DateTime date;
  @override
  final int dailyMinor;
  @override
  final int cumulativeMinor;

  @override
  String toString() {
    return 'TimelinePoint(date: $date, dailyMinor: $dailyMinor, cumulativeMinor: $cumulativeMinor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelinePointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dailyMinor, dailyMinor) ||
                other.dailyMinor == dailyMinor) &&
            (identical(other.cumulativeMinor, cumulativeMinor) ||
                other.cumulativeMinor == cumulativeMinor));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, date, dailyMinor, cumulativeMinor);

  /// Create a copy of TimelinePoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelinePointImplCopyWith<_$TimelinePointImpl> get copyWith =>
      __$$TimelinePointImplCopyWithImpl<_$TimelinePointImpl>(this, _$identity);
}

abstract class _TimelinePoint implements TimelinePoint {
  const factory _TimelinePoint(
      {required final DateTime date,
      required final int dailyMinor,
      required final int cumulativeMinor}) = _$TimelinePointImpl;

  @override
  DateTime get date;
  @override
  int get dailyMinor;
  @override
  int get cumulativeMinor;

  /// Create a copy of TimelinePoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimelinePointImplCopyWith<_$TimelinePointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ReportData {
  int get totalMinor => throw _privateConstructorUsedError;
  int get expenseCount => throw _privateConstructorUsedError;
  List<CategorySlice> get categories => throw _privateConstructorUsedError;
  List<MemberSpend> get members => throw _privateConstructorUsedError;
  List<TimelinePoint> get timeline => throw _privateConstructorUsedError;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportDataCopyWith<ReportData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportDataCopyWith<$Res> {
  factory $ReportDataCopyWith(
          ReportData value, $Res Function(ReportData) then) =
      _$ReportDataCopyWithImpl<$Res, ReportData>;
  @useResult
  $Res call(
      {int totalMinor,
      int expenseCount,
      List<CategorySlice> categories,
      List<MemberSpend> members,
      List<TimelinePoint> timeline});
}

/// @nodoc
class _$ReportDataCopyWithImpl<$Res, $Val extends ReportData>
    implements $ReportDataCopyWith<$Res> {
  _$ReportDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMinor = null,
    Object? expenseCount = null,
    Object? categories = null,
    Object? members = null,
    Object? timeline = null,
  }) {
    return _then(_value.copyWith(
      totalMinor: null == totalMinor
          ? _value.totalMinor
          : totalMinor // ignore: cast_nullable_to_non_nullable
              as int,
      expenseCount: null == expenseCount
          ? _value.expenseCount
          : expenseCount // ignore: cast_nullable_to_non_nullable
              as int,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategorySlice>,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<MemberSpend>,
      timeline: null == timeline
          ? _value.timeline
          : timeline // ignore: cast_nullable_to_non_nullable
              as List<TimelinePoint>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportDataImplCopyWith<$Res>
    implements $ReportDataCopyWith<$Res> {
  factory _$$ReportDataImplCopyWith(
          _$ReportDataImpl value, $Res Function(_$ReportDataImpl) then) =
      __$$ReportDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalMinor,
      int expenseCount,
      List<CategorySlice> categories,
      List<MemberSpend> members,
      List<TimelinePoint> timeline});
}

/// @nodoc
class __$$ReportDataImplCopyWithImpl<$Res>
    extends _$ReportDataCopyWithImpl<$Res, _$ReportDataImpl>
    implements _$$ReportDataImplCopyWith<$Res> {
  __$$ReportDataImplCopyWithImpl(
      _$ReportDataImpl _value, $Res Function(_$ReportDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMinor = null,
    Object? expenseCount = null,
    Object? categories = null,
    Object? members = null,
    Object? timeline = null,
  }) {
    return _then(_$ReportDataImpl(
      totalMinor: null == totalMinor
          ? _value.totalMinor
          : totalMinor // ignore: cast_nullable_to_non_nullable
              as int,
      expenseCount: null == expenseCount
          ? _value.expenseCount
          : expenseCount // ignore: cast_nullable_to_non_nullable
              as int,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategorySlice>,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<MemberSpend>,
      timeline: null == timeline
          ? _value._timeline
          : timeline // ignore: cast_nullable_to_non_nullable
              as List<TimelinePoint>,
    ));
  }
}

/// @nodoc

class _$ReportDataImpl extends _ReportData {
  const _$ReportDataImpl(
      {this.totalMinor = 0,
      this.expenseCount = 0,
      final List<CategorySlice> categories = const <CategorySlice>[],
      final List<MemberSpend> members = const <MemberSpend>[],
      final List<TimelinePoint> timeline = const <TimelinePoint>[]})
      : _categories = categories,
        _members = members,
        _timeline = timeline,
        super._();

  @override
  @JsonKey()
  final int totalMinor;
  @override
  @JsonKey()
  final int expenseCount;
  final List<CategorySlice> _categories;
  @override
  @JsonKey()
  List<CategorySlice> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<MemberSpend> _members;
  @override
  @JsonKey()
  List<MemberSpend> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  final List<TimelinePoint> _timeline;
  @override
  @JsonKey()
  List<TimelinePoint> get timeline {
    if (_timeline is EqualUnmodifiableListView) return _timeline;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeline);
  }

  @override
  String toString() {
    return 'ReportData(totalMinor: $totalMinor, expenseCount: $expenseCount, categories: $categories, members: $members, timeline: $timeline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportDataImpl &&
            (identical(other.totalMinor, totalMinor) ||
                other.totalMinor == totalMinor) &&
            (identical(other.expenseCount, expenseCount) ||
                other.expenseCount == expenseCount) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality().equals(other._timeline, _timeline));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalMinor,
      expenseCount,
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_members),
      const DeepCollectionEquality().hash(_timeline));

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportDataImplCopyWith<_$ReportDataImpl> get copyWith =>
      __$$ReportDataImplCopyWithImpl<_$ReportDataImpl>(this, _$identity);
}

abstract class _ReportData extends ReportData {
  const factory _ReportData(
      {final int totalMinor,
      final int expenseCount,
      final List<CategorySlice> categories,
      final List<MemberSpend> members,
      final List<TimelinePoint> timeline}) = _$ReportDataImpl;
  const _ReportData._() : super._();

  @override
  int get totalMinor;
  @override
  int get expenseCount;
  @override
  List<CategorySlice> get categories;
  @override
  List<MemberSpend> get members;
  @override
  List<TimelinePoint> get timeline;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportDataImplCopyWith<_$ReportDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
