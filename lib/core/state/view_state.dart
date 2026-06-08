import 'package:freezed_annotation/freezed_annotation.dart';

part 'view_state.freezed.dart';

@freezed
sealed class ViewState<T> with _$ViewState<T> {
  const factory ViewState.initial() = ViewInitial<T>;
  const factory ViewState.loading() = ViewLoading<T>;
  const factory ViewState.loaded(T data) = ViewLoaded<T>;
  const factory ViewState.error(String message) = ViewError<T>;
}
