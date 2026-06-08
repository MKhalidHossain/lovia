import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lovia/features/auth/domain/entities/user.dart';

part 'auth_status.freezed.dart';

@freezed
sealed class AuthStatus with _$AuthStatus {

  const factory AuthStatus.unknown() = Unknown;

  const factory AuthStatus.authenticating() = Authenticating;

  const factory AuthStatus.authenticated(User user) = Authenticated;

  const factory AuthStatus.unauthenticated() = Unauthenticated;

  const factory AuthStatus.error(String message) = AuthError;
}
