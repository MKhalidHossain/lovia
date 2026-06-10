abstract final class Env {

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
    // defaultValue: 'http://localhost:3000',
  );

  static const Duration networkTimeout = Duration(seconds: 20);
}
