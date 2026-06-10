abstract final class ApiPaths {
  // Email / password
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';

  // Social + guest
  static const String google = '/auth/google';
  static const String facebook = '/auth/facebook';
  static const String guest = '/auth/guest';

  // Session lifecycle
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Profile
  static const String usersMe = '/users/me';
}
