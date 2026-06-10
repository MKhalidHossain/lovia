import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lovia/core/error/exceptions.dart';
import 'package:lovia/features/auth/domain/entities/auth_provider.dart';

/// A provider token to exchange with the backend.
///
/// Google returns an [idToken]; Facebook returns an [accessToken].
class SocialCredential {
  const SocialCredential({
    required this.provider,
    this.idToken,
    this.accessToken,
  });

  final AuthProvider provider;
  final String? idToken;
  final String? accessToken;
}

// ignore: one_member_abstracts — provider boundary kept for layering.
abstract interface class AuthSocialDataSource {
  Future<SocialCredential> signIn(AuthProvider provider);

  /// Sign out of every social SDK (best-effort, called on logout).
  Future<void> signOut();
}

class AuthSocialDataSourceImpl implements AuthSocialDataSource {
  const AuthSocialDataSourceImpl();

  @override
  Future<SocialCredential> signIn(AuthProvider provider) {
    return switch (provider) {
      AuthProvider.google => _google(),
      AuthProvider.facebook => _facebook(),
      _ => throw const UnauthorizedException('Unsupported provider'),
    };
  }

  @override
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } on Object catch (_) {}
    try {
      await FacebookAuth.instance.logOut();
    } on Object catch (_) {}
  }

  Future<SocialCredential> _google() async {
    try {
      final account = await GoogleSignIn().signIn();
      if (account == null) {
        throw const UnauthorizedException('Google sign-in cancelled');
      }
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw const UnauthorizedException('Google returned no ID token');
      }
      return SocialCredential(provider: AuthProvider.google, idToken: idToken);
    } on UnauthorizedException {
      rethrow;
    } on Object catch (e) {
      throw NetworkException('Google sign-in failed: $e');
    }
  }

  Future<SocialCredential> _facebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success || result.accessToken == null) {
        throw const UnauthorizedException('Facebook sign-in cancelled');
      }
      return SocialCredential(
        provider: AuthProvider.facebook,
        accessToken: result.accessToken!.tokenString,
      );
    } on UnauthorizedException {
      rethrow;
    } on Object catch (e) {
      throw NetworkException('Facebook sign-in failed: $e');
    }
  }
}
