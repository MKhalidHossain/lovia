import 'package:flutter/foundation.dart';

@immutable
sealed class Failure {
  const Failure(this.message);

  final String message;

  @override
  bool operator ==(Object other) =>
      other is Failure &&
      other.runtimeType == runtimeType &&
      other.message == message;

  @override
  int get hashCode => Object.hash(runtimeType, message);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection. Please check your network.',
  ]);
}

final class ServerFailure extends Failure {
  const ServerFailure({
    required this.code,
    required String message,
  }) : super(message);

  final int code;

  @override
  bool operator ==(Object other) =>
      other is ServerFailure && other.code == code && other.message == message;

  @override
  int get hashCode => Object.hash(runtimeType, code, message);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Your session is invalid. Please sign in again.',
  ]);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not access local storage.']);
}

final class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    this.fields = const {},
  }) : super(message);

  final Map<String, String> fields;

  @override
  bool operator ==(Object other) =>
      other is ValidationFailure &&
      other.message == message &&
      mapEquals(other.fields, fields);

  @override
  int get hashCode => Object.hash(runtimeType, message, Object.hashAll(fields.entries));
}

final class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}
