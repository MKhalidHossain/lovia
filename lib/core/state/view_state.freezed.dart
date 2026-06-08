// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ViewState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ViewInitial<T> value) initial,
    required TResult Function(ViewLoading<T> value) loading,
    required TResult Function(ViewLoaded<T> value) loaded,
    required TResult Function(ViewError<T> value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ViewInitial<T> value)? initial,
    TResult? Function(ViewLoading<T> value)? loading,
    TResult? Function(ViewLoaded<T> value)? loaded,
    TResult? Function(ViewError<T> value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ViewInitial<T> value)? initial,
    TResult Function(ViewLoading<T> value)? loading,
    TResult Function(ViewLoaded<T> value)? loaded,
    TResult Function(ViewError<T> value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ViewStateCopyWith<T, $Res> {
  factory $ViewStateCopyWith(
    ViewState<T> value,
    $Res Function(ViewState<T>) then,
  ) = _$ViewStateCopyWithImpl<T, $Res, ViewState<T>>;
}

/// @nodoc
class _$ViewStateCopyWithImpl<T, $Res, $Val extends ViewState<T>>
    implements $ViewStateCopyWith<T, $Res> {
  _$ViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ViewState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ViewInitialImplCopyWith<T, $Res> {
  factory _$$ViewInitialImplCopyWith(
    _$ViewInitialImpl<T> value,
    $Res Function(_$ViewInitialImpl<T>) then,
  ) = __$$ViewInitialImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$ViewInitialImplCopyWithImpl<T, $Res>
    extends _$ViewStateCopyWithImpl<T, $Res, _$ViewInitialImpl<T>>
    implements _$$ViewInitialImplCopyWith<T, $Res> {
  __$$ViewInitialImplCopyWithImpl(
    _$ViewInitialImpl<T> _value,
    $Res Function(_$ViewInitialImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of ViewState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ViewInitialImpl<T> implements ViewInitial<T> {
  const _$ViewInitialImpl();

  @override
  String toString() {
    return 'ViewState<$T>.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ViewInitialImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ViewInitial<T> value) initial,
    required TResult Function(ViewLoading<T> value) loading,
    required TResult Function(ViewLoaded<T> value) loaded,
    required TResult Function(ViewError<T> value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ViewInitial<T> value)? initial,
    TResult? Function(ViewLoading<T> value)? loading,
    TResult? Function(ViewLoaded<T> value)? loaded,
    TResult? Function(ViewError<T> value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ViewInitial<T> value)? initial,
    TResult Function(ViewLoading<T> value)? loading,
    TResult Function(ViewLoaded<T> value)? loaded,
    TResult Function(ViewError<T> value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class ViewInitial<T> implements ViewState<T> {
  const factory ViewInitial() = _$ViewInitialImpl<T>;
}

/// @nodoc
abstract class _$$ViewLoadingImplCopyWith<T, $Res> {
  factory _$$ViewLoadingImplCopyWith(
    _$ViewLoadingImpl<T> value,
    $Res Function(_$ViewLoadingImpl<T>) then,
  ) = __$$ViewLoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$ViewLoadingImplCopyWithImpl<T, $Res>
    extends _$ViewStateCopyWithImpl<T, $Res, _$ViewLoadingImpl<T>>
    implements _$$ViewLoadingImplCopyWith<T, $Res> {
  __$$ViewLoadingImplCopyWithImpl(
    _$ViewLoadingImpl<T> _value,
    $Res Function(_$ViewLoadingImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of ViewState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ViewLoadingImpl<T> implements ViewLoading<T> {
  const _$ViewLoadingImpl();

  @override
  String toString() {
    return 'ViewState<$T>.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ViewLoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ViewInitial<T> value) initial,
    required TResult Function(ViewLoading<T> value) loading,
    required TResult Function(ViewLoaded<T> value) loaded,
    required TResult Function(ViewError<T> value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ViewInitial<T> value)? initial,
    TResult? Function(ViewLoading<T> value)? loading,
    TResult? Function(ViewLoaded<T> value)? loaded,
    TResult? Function(ViewError<T> value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ViewInitial<T> value)? initial,
    TResult Function(ViewLoading<T> value)? loading,
    TResult Function(ViewLoaded<T> value)? loaded,
    TResult Function(ViewError<T> value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ViewLoading<T> implements ViewState<T> {
  const factory ViewLoading() = _$ViewLoadingImpl<T>;
}

/// @nodoc
abstract class _$$ViewLoadedImplCopyWith<T, $Res> {
  factory _$$ViewLoadedImplCopyWith(
    _$ViewLoadedImpl<T> value,
    $Res Function(_$ViewLoadedImpl<T>) then,
  ) = __$$ViewLoadedImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$ViewLoadedImplCopyWithImpl<T, $Res>
    extends _$ViewStateCopyWithImpl<T, $Res, _$ViewLoadedImpl<T>>
    implements _$$ViewLoadedImplCopyWith<T, $Res> {
  __$$ViewLoadedImplCopyWithImpl(
    _$ViewLoadedImpl<T> _value,
    $Res Function(_$ViewLoadedImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of ViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = freezed}) {
    return _then(
      _$ViewLoadedImpl<T>(
        freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as T,
      ),
    );
  }
}

/// @nodoc

class _$ViewLoadedImpl<T> implements ViewLoaded<T> {
  const _$ViewLoadedImpl(this.data);

  @override
  final T data;

  @override
  String toString() {
    return 'ViewState<$T>.loaded(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ViewLoadedImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  /// Create a copy of ViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ViewLoadedImplCopyWith<T, _$ViewLoadedImpl<T>> get copyWith =>
      __$$ViewLoadedImplCopyWithImpl<T, _$ViewLoadedImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ViewInitial<T> value) initial,
    required TResult Function(ViewLoading<T> value) loading,
    required TResult Function(ViewLoaded<T> value) loaded,
    required TResult Function(ViewError<T> value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ViewInitial<T> value)? initial,
    TResult? Function(ViewLoading<T> value)? loading,
    TResult? Function(ViewLoaded<T> value)? loaded,
    TResult? Function(ViewError<T> value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ViewInitial<T> value)? initial,
    TResult Function(ViewLoading<T> value)? loading,
    TResult Function(ViewLoaded<T> value)? loaded,
    TResult Function(ViewError<T> value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ViewLoaded<T> implements ViewState<T> {
  const factory ViewLoaded(final T data) = _$ViewLoadedImpl<T>;

  T get data;

  /// Create a copy of ViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ViewLoadedImplCopyWith<T, _$ViewLoadedImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ViewErrorImplCopyWith<T, $Res> {
  factory _$$ViewErrorImplCopyWith(
    _$ViewErrorImpl<T> value,
    $Res Function(_$ViewErrorImpl<T>) then,
  ) = __$$ViewErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ViewErrorImplCopyWithImpl<T, $Res>
    extends _$ViewStateCopyWithImpl<T, $Res, _$ViewErrorImpl<T>>
    implements _$$ViewErrorImplCopyWith<T, $Res> {
  __$$ViewErrorImplCopyWithImpl(
    _$ViewErrorImpl<T> _value,
    $Res Function(_$ViewErrorImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of ViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ViewErrorImpl<T>(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ViewErrorImpl<T> implements ViewError<T> {
  const _$ViewErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ViewState<$T>.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ViewErrorImpl<T> &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ViewErrorImplCopyWith<T, _$ViewErrorImpl<T>> get copyWith =>
      __$$ViewErrorImplCopyWithImpl<T, _$ViewErrorImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ViewInitial<T> value) initial,
    required TResult Function(ViewLoading<T> value) loading,
    required TResult Function(ViewLoaded<T> value) loaded,
    required TResult Function(ViewError<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ViewInitial<T> value)? initial,
    TResult? Function(ViewLoading<T> value)? loading,
    TResult? Function(ViewLoaded<T> value)? loaded,
    TResult? Function(ViewError<T> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ViewInitial<T> value)? initial,
    TResult Function(ViewLoading<T> value)? loading,
    TResult Function(ViewLoaded<T> value)? loaded,
    TResult Function(ViewError<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ViewError<T> implements ViewState<T> {
  const factory ViewError(final String message) = _$ViewErrorImpl<T>;

  String get message;

  /// Create a copy of ViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ViewErrorImplCopyWith<T, _$ViewErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
