abstract final class Env {

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://lovia-backend-rvud.onrender.com',
    // defaultValue: 'http://localhost:3000',
  );

  static const Duration networkTimeout = Duration(seconds: 20);
}
