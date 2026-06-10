import 'dart:async';

import 'package:get/get.dart';
import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/auth/domain/entities/auth_provider.dart';
import 'package:lovia/features/auth/domain/entities/user.dart';
import 'package:lovia/features/auth/domain/usecases/check_auth_status.dart';
import 'package:lovia/features/auth/domain/usecases/get_current_user.dart';
import 'package:lovia/features/auth/domain/usecases/login_user.dart';
import 'package:lovia/features/auth/domain/usecases/logout_user.dart';
import 'package:lovia/features/auth/domain/usecases/register_user.dart';
import 'package:lovia/features/auth/domain/usecases/request_password_reset.dart';
import 'package:lovia/features/auth/domain/usecases/reset_password.dart';
import 'package:lovia/features/auth/domain/usecases/sign_in_as_guest.dart';
import 'package:lovia/features/auth/domain/usecases/sign_in_with_provider.dart';
import 'package:lovia/features/auth/domain/usecases/update_language.dart';
import 'package:lovia/features/auth/domain/usecases/verify_otp.dart';
import 'package:lovia/features/auth/presentation/controllers/auth_status.dart';

class AuthController extends GetxController {
  AuthController({
    required CheckAuthStatus checkAuthStatus,
    required LoginUser loginUser,
    required RegisterUser registerUser,
    required LogoutUser logoutUser,
    required GetCurrentUser getCurrentUser,
    required RequestPasswordReset requestPasswordReset,
    required VerifyOtp verifyOtp,
    required ResetPassword resetPassword,
    required SignInWithProvider signInWithProvider,
    required SignInAsGuest signInAsGuest,
    required UpdateLanguage updateLanguage,
  })  : _checkAuthStatus = checkAuthStatus,
        _signInWithProvider = signInWithProvider,
        _signInAsGuest = signInAsGuest,
        _loginUser = loginUser,
        _registerUser = registerUser,
        _logoutUser = logoutUser,
        _getCurrentUser = getCurrentUser,
        _requestPasswordReset = requestPasswordReset,
        _verifyOtp = verifyOtp,
        _resetPassword = resetPassword,
        _updateLanguage = updateLanguage;

  final CheckAuthStatus _checkAuthStatus;
  final LoginUser _loginUser;
  final RegisterUser _registerUser;
  final LogoutUser _logoutUser;
  final GetCurrentUser _getCurrentUser;
  final RequestPasswordReset _requestPasswordReset;
  final VerifyOtp _verifyOtp;
  final ResetPassword _resetPassword;
  final SignInWithProvider _signInWithProvider;
  final SignInAsGuest _signInAsGuest;
  final UpdateLanguage _updateLanguage;

  final Rx<AuthStatus> status = const AuthStatus.unknown().obs;

  final RxBool isBusy = false.obs;

  User? get currentUser {
    final s = status.value;
    return s is Authenticated ? s.user : null;
  }

  Future<void> bootstrap() async {
    status.value = const AuthStatus.unknown();
    final result = await _checkAuthStatus(const NoParams());
    status.value = switch (result) {
      Success(:final value) => AuthStatus.authenticated(value),
      Failed() => const AuthStatus.unauthenticated(),
    };
  }

  Future<void> login({required String email, required String password}) async {
    status.value = const AuthStatus.authenticating();
    isBusy.value = true;
    final result = await _loginUser(LoginParams(email: email, password: password));
    isBusy.value = false;
    switch (result) {
      case Success(:final value):
        status.value = AuthStatus.authenticated(value);
        unawaited(Get.offAllNamed<void>(AppRoutes.shell));
      case Failed(:final failure):
        status.value = AuthStatus.error(failure.message);
        _toast('Sign in failed', failure.message);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isBusy.value = true;
    final result = await _registerUser(
      RegisterParams(name: name, email: email, password: password),
    );
    isBusy.value = false;
    switch (result) {
      case Success():
        status.value = const AuthStatus.unauthenticated();
        unawaited(Get.offAllNamed<void>(AppRoutes.login));
        _toast('Welcome to Lovia', 'Account created — please sign in.');
      case Failed(:final failure):
        status.value = AuthStatus.error(failure.message);
        _toast('Sign up failed', failure.message);
    }
  }

  Future<void> signInWith(AuthProvider provider) async {
    status.value = const AuthStatus.authenticating();
    isBusy.value = true;
    final result = await _signInWithProvider(provider);
    isBusy.value = false;
    switch (result) {
      case Success(:final value):
        status.value = AuthStatus.authenticated(value);
        unawaited(Get.offAllNamed<void>(AppRoutes.shell));
      case Failed(:final failure):
        status.value = const AuthStatus.unauthenticated();
        _toast('${provider.label} sign-in failed', failure.message);
    }
  }

  Future<void> continueAsGuest() async {
    status.value = const AuthStatus.authenticating();
    isBusy.value = true;
    final result = await _signInAsGuest(const NoParams());
    isBusy.value = false;
    switch (result) {
      case Success(:final value):
        status.value = AuthStatus.authenticated(value);
        unawaited(Get.offAllNamed<void>(AppRoutes.shell));
      case Failed(:final failure):
        status.value = AuthStatus.error(failure.message);
        _toast('Could not continue', failure.message);
    }
  }

  Future<void> refreshUser() async {
    final result = await _getCurrentUser(const NoParams());
    if (result case Success(:final value)) {
      status.value = AuthStatus.authenticated(value);
    }
  }

  /// Persist a language preference to the backend, updating the cached user.
  Future<bool> updateLanguage(String language) async {
    final result = await _updateLanguage(language);
    if (result case Success(:final value)) {
      status.value = AuthStatus.authenticated(value);
      return true;
    }
    return false;
  }

  /// Called by the network layer when a refresh fails (401 with no valid
  /// refresh token) — drops the session and returns to the auth screen.
  Future<void> handleSessionExpired() async {
    if (status.value is! Authenticated) return;
    status.value = const AuthStatus.unauthenticated();
    _toast('Session expired', 'Please sign in again.');
    unawaited(Get.offAllNamed<void>(AppRoutes.onboarding));
  }

  Future<void> logout() async {
    await _logoutUser(const NoParams());
    status.value = const AuthStatus.unauthenticated();
    unawaited(Get.offAllNamed<void>(AppRoutes.onboarding));
  }

  Future<bool> requestPasswordReset(String email) {
    return _boolRun(
      () => _requestPasswordReset(email),
      successMsg: 'OTP sent to your email.',
    );
  }

  Future<bool> verifyOtp({required String email, required String otp}) {
    return _boolRun(
      () => _verifyOtp(VerifyOtpParams(email: email, otp: otp)),
      successMsg: 'OTP verified.',
    );
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) {
    return _boolRun(
      () => _resetPassword(
        ResetPasswordParams(email: email, otp: otp, newPassword: newPassword),
      ),
      successMsg: 'Password updated — please sign in.',
    );
  }

  Future<bool> _boolRun(
    Future<Result<Unit, Failure>> Function() action, {
    required String successMsg,
  }) async {
    isBusy.value = true;
    final result = await action();
    isBusy.value = false;
    switch (result) {
      case Success():
        _toast('Success', successMsg);
        return true;
      case Failed(:final failure):
        _toast('Something went wrong', failure.message);
        return false;
    }
  }

  void _toast(String title, String message) {
    Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
  }
}
