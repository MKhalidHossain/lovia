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
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PremiumPlan {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get price => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  List<String> get perks => throw _privateConstructorUsedError;
  bool get highlighted => throw _privateConstructorUsedError;

  /// Create a copy of PremiumPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PremiumPlanCopyWith<PremiumPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PremiumPlanCopyWith<$Res> {
  factory $PremiumPlanCopyWith(
    PremiumPlan value,
    $Res Function(PremiumPlan) then,
  ) = _$PremiumPlanCopyWithImpl<$Res, PremiumPlan>;
  @useResult
  $Res call({
    String id,
    String title,
    String price,
    String period,
    List<String> perks,
    bool highlighted,
  });
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
    Object? price = null,
    Object? period = null,
    Object? perks = null,
    Object? highlighted = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as String,
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as String,
            perks: null == perks
                ? _value.perks
                : perks // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            highlighted: null == highlighted
                ? _value.highlighted
                : highlighted // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PremiumPlanImplCopyWith<$Res>
    implements $PremiumPlanCopyWith<$Res> {
  factory _$$PremiumPlanImplCopyWith(
    _$PremiumPlanImpl value,
    $Res Function(_$PremiumPlanImpl) then,
  ) = __$$PremiumPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String price,
    String period,
    List<String> perks,
    bool highlighted,
  });
}

/// @nodoc
class __$$PremiumPlanImplCopyWithImpl<$Res>
    extends _$PremiumPlanCopyWithImpl<$Res, _$PremiumPlanImpl>
    implements _$$PremiumPlanImplCopyWith<$Res> {
  __$$PremiumPlanImplCopyWithImpl(
    _$PremiumPlanImpl _value,
    $Res Function(_$PremiumPlanImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PremiumPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? period = null,
    Object? perks = null,
    Object? highlighted = null,
  }) {
    return _then(
      _$PremiumPlanImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as String,
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as String,
        perks: null == perks
            ? _value._perks
            : perks // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        highlighted: null == highlighted
            ? _value.highlighted
            : highlighted // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$PremiumPlanImpl implements _PremiumPlan {
  const _$PremiumPlanImpl({
    required this.id,
    required this.title,
    required this.price,
    required this.period,
    required final List<String> perks,
    this.highlighted = false,
  }) : _perks = perks;

  @override
  final String id;
  @override
  final String title;
  @override
  final String price;
  @override
  final String period;
  final List<String> _perks;
  @override
  List<String> get perks {
    if (_perks is EqualUnmodifiableListView) return _perks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_perks);
  }

  @override
  @JsonKey()
  final bool highlighted;

  @override
  String toString() {
    return 'PremiumPlan(id: $id, title: $title, price: $price, period: $period, perks: $perks, highlighted: $highlighted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PremiumPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.period, period) || other.period == period) &&
            const DeepCollectionEquality().equals(other._perks, _perks) &&
            (identical(other.highlighted, highlighted) ||
                other.highlighted == highlighted));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    price,
    period,
    const DeepCollectionEquality().hash(_perks),
    highlighted,
  );

  /// Create a copy of PremiumPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PremiumPlanImplCopyWith<_$PremiumPlanImpl> get copyWith =>
      __$$PremiumPlanImplCopyWithImpl<_$PremiumPlanImpl>(this, _$identity);
}

abstract class _PremiumPlan implements PremiumPlan {
  const factory _PremiumPlan({
    required final String id,
    required final String title,
    required final String price,
    required final String period,
    required final List<String> perks,
    final bool highlighted,
  }) = _$PremiumPlanImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  String get price;
  @override
  String get period;
  @override
  List<String> get perks;
  @override
  bool get highlighted;

  /// Create a copy of PremiumPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PremiumPlanImplCopyWith<_$PremiumPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
