enum AuthProvider {
  email,
  google,
  apple,
  facebook,
  guest;

  String get label => switch (this) {
        AuthProvider.email => 'Email',
        AuthProvider.google => 'Google',
        AuthProvider.apple => 'Apple',
        AuthProvider.facebook => 'Facebook',
        AuthProvider.guest => 'Guest',
      };

  String get storageValue => name;

  static AuthProvider fromStorage(String? value) {
    return AuthProvider.values.firstWhere(
      (p) => p.name == value,
      orElse: () => AuthProvider.email,
    );
  }
}
