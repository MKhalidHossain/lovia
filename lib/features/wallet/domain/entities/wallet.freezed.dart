// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Wallet {
  int get coins => throw _privateConstructorUsedError;
  int get diamonds => throw _privateConstructorUsedError;
  List<WalletTransaction> get transactions =>
      throw _privateConstructorUsedError;
  DateTime? get lastCheckIn => throw _privateConstructorUsedError;

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletCopyWith<Wallet> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletCopyWith<$Res> {
  factory $WalletCopyWith(Wallet value, $Res Function(Wallet) then) =
      _$WalletCopyWithImpl<$Res, Wallet>;
  @useResult
  $Res call({
    int coins,
    int diamonds,
    List<WalletTransaction> transactions,
    DateTime? lastCheckIn,
  });
}

/// @nodoc
class _$WalletCopyWithImpl<$Res, $Val extends Wallet>
    implements $WalletCopyWith<$Res> {
  _$WalletCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coins = null,
    Object? diamonds = null,
    Object? transactions = null,
    Object? lastCheckIn = freezed,
  }) {
    return _then(
      _value.copyWith(
            coins: null == coins
                ? _value.coins
                : coins // ignore: cast_nullable_to_non_nullable
                      as int,
            diamonds: null == diamonds
                ? _value.diamonds
                : diamonds // ignore: cast_nullable_to_non_nullable
                      as int,
            transactions: null == transactions
                ? _value.transactions
                : transactions // ignore: cast_nullable_to_non_nullable
                      as List<WalletTransaction>,
            lastCheckIn: freezed == lastCheckIn
                ? _value.lastCheckIn
                : lastCheckIn // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WalletImplCopyWith<$Res> implements $WalletCopyWith<$Res> {
  factory _$$WalletImplCopyWith(
    _$WalletImpl value,
    $Res Function(_$WalletImpl) then,
  ) = __$$WalletImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int coins,
    int diamonds,
    List<WalletTransaction> transactions,
    DateTime? lastCheckIn,
  });
}

/// @nodoc
class __$$WalletImplCopyWithImpl<$Res>
    extends _$WalletCopyWithImpl<$Res, _$WalletImpl>
    implements _$$WalletImplCopyWith<$Res> {
  __$$WalletImplCopyWithImpl(
    _$WalletImpl _value,
    $Res Function(_$WalletImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coins = null,
    Object? diamonds = null,
    Object? transactions = null,
    Object? lastCheckIn = freezed,
  }) {
    return _then(
      _$WalletImpl(
        coins: null == coins
            ? _value.coins
            : coins // ignore: cast_nullable_to_non_nullable
                  as int,
        diamonds: null == diamonds
            ? _value.diamonds
            : diamonds // ignore: cast_nullable_to_non_nullable
                  as int,
        transactions: null == transactions
            ? _value._transactions
            : transactions // ignore: cast_nullable_to_non_nullable
                  as List<WalletTransaction>,
        lastCheckIn: freezed == lastCheckIn
            ? _value.lastCheckIn
            : lastCheckIn // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$WalletImpl extends _Wallet {
  const _$WalletImpl({
    required this.coins,
    required this.diamonds,
    required final List<WalletTransaction> transactions,
    this.lastCheckIn,
  }) : _transactions = transactions,
       super._();

  @override
  final int coins;
  @override
  final int diamonds;
  final List<WalletTransaction> _transactions;
  @override
  List<WalletTransaction> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  final DateTime? lastCheckIn;

  @override
  String toString() {
    return 'Wallet(coins: $coins, diamonds: $diamonds, transactions: $transactions, lastCheckIn: $lastCheckIn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletImpl &&
            (identical(other.coins, coins) || other.coins == coins) &&
            (identical(other.diamonds, diamonds) ||
                other.diamonds == diamonds) &&
            const DeepCollectionEquality().equals(
              other._transactions,
              _transactions,
            ) &&
            (identical(other.lastCheckIn, lastCheckIn) ||
                other.lastCheckIn == lastCheckIn));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    coins,
    diamonds,
    const DeepCollectionEquality().hash(_transactions),
    lastCheckIn,
  );

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletImplCopyWith<_$WalletImpl> get copyWith =>
      __$$WalletImplCopyWithImpl<_$WalletImpl>(this, _$identity);
}

abstract class _Wallet extends Wallet {
  const factory _Wallet({
    required final int coins,
    required final int diamonds,
    required final List<WalletTransaction> transactions,
    final DateTime? lastCheckIn,
  }) = _$WalletImpl;
  const _Wallet._() : super._();

  @override
  int get coins;
  @override
  int get diamonds;
  @override
  List<WalletTransaction> get transactions;
  @override
  DateTime? get lastCheckIn;

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletImplCopyWith<_$WalletImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
