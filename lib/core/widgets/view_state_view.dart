import 'package:flutter/material.dart';
import 'package:lovia/core/state/view_state.dart';
import 'package:lovia/core/widgets/error_state.dart';

class ViewStateView<T> extends StatelessWidget {
  const ViewStateView({
    required this.state,
    required this.builder,
    this.onRetry,
    this.loading,
    super.key,
  });

  final ViewState<T> state;
  final Widget Function(BuildContext context, T data) builder;
  final VoidCallback? onRetry;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ViewInitial<T>() ||
      ViewLoading<T>() =>
        loading ?? const Center(child: CircularProgressIndicator()),
      ViewError<T>(:final message) =>
        ErrorState(message: message, onRetry: onRetry),
      ViewLoaded<T>(:final data) => builder(context, data),
    };
  }
}
