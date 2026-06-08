import 'package:lovia/core/error/failures.dart';

sealed class Result<S, F extends Failure> {
  const Result();

  bool get isSuccess => this is Success<S, F>;

  T fold<T>(T Function(S value) onSuccess, T Function(F failure) onFailure) {
    return switch (this) {
      Success<S, F>(:final value) => onSuccess(value),
      Failed<S, F>(:final failure) => onFailure(failure),
    };
  }
}

final class Success<S, F extends Failure> extends Result<S, F> {
  const Success(this.value);
  final S value;
}

final class Failed<S, F extends Failure> extends Result<S, F> {
  const Failed(this.failure);
  final F failure;
}

class Unit {
  const Unit._();
  static const Unit value = Unit._();
}
