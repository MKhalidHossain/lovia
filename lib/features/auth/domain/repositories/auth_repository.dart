import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/features/auth/domain/entities/auth_provider.dart';
import 'package:lovia/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {

  Future<Result<Unit, Failure>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<User, Failure>> login({
    required String email,
    required String password,
  });

  Future<Result<User, Failure>> getCurrentUser();

  Future<Result<User, Failure>> signInWithProvider(AuthProvider provider);

  Future<Result<User, Failure>> loginAsGuest();

  Future<Result<User, Failure>> checkAuthStatus();

  /// Persist the user's language preference (`PATCH /users/me`).
  Future<Result<User, Failure>> updateLanguage(String language);

  Future<Result<Unit, Failure>> logout();

  Future<Result<Unit, Failure>> requestPasswordReset({required String email});

  Future<Result<Unit, Failure>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Result<Unit, Failure>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}
