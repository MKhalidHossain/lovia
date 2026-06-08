import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lovia/core/error/exceptions.dart';
import 'package:lovia/features/auth/domain/entities/auth_provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAccount {
  const SocialAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.provider,
  });

  final String id;
  final String name;
  final String email;
  final AuthProvider provider;
}

// ignore: one_member_abstracts — provider boundary kept for layering.
abstract interface class AuthSocialDataSource {
  Future<SocialAccount> signIn(AuthProvider provider);
}

class AuthSocialDataSourceImpl implements AuthSocialDataSource {
  const AuthSocialDataSourceImpl();

  @override
  Future<SocialAccount> signIn(AuthProvider provider) {
    return switch (provider) {
      AuthProvider.google => _google(),
      AuthProvider.apple => _apple(),
      AuthProvider.facebook => _facebook(),
      _ => throw const UnauthorizedException('Unsupported provider'),
    };
  }

  Future<SocialAccount> _google() async {
    try {
      final account = await GoogleSignIn().signIn();
      if (account == null) {
        throw const UnauthorizedException('Google sign-in cancelled');
      }
      return SocialAccount(
        id: account.id,
        name: account.displayName ?? account.email.split('@').first,
        email: account.email,
        provider: AuthProvider.google,
      );
    } on UnauthorizedException {
      rethrow;
    } on Object catch (e) {
      throw NetworkException('Google sign-in failed: $e');
    }
  }

  Future<SocialAccount> _apple() async {
    try {
      final cred = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final name = [cred.givenName, cred.familyName]
          .whereType<String>()
          .join(' ')
          .trim();
      return SocialAccount(
        id: cred.userIdentifier ?? cred.email ?? 'apple-user',
        name: name.isEmpty ? 'Apple User' : name,
        email: cred.email ?? '',
        provider: AuthProvider.apple,
      );
    } on SignInWithAppleAuthorizationException {
      throw const UnauthorizedException('Apple sign-in cancelled');
    } on Object catch (e) {
      throw NetworkException('Apple sign-in failed: $e');
    }
  }

  Future<SocialAccount> _facebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        throw const UnauthorizedException('Facebook sign-in cancelled');
      }
      final data = await FacebookAuth.instance.getUserData();
      return SocialAccount(
        id: data['id']?.toString() ?? 'facebook-user',
        name: data['name']?.toString() ?? 'Facebook User',
        email: data['email']?.toString() ?? '',
        provider: AuthProvider.facebook,
      );
    } on UnauthorizedException {
      rethrow;
    } on Object catch (e) {
      throw NetworkException('Facebook sign-in failed: $e');
    }
  }
}
