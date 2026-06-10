import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lovia/core/error/exceptions.dart';
import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:lovia/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lovia/features/auth/data/datasources/auth_social_data_source.dart';
import 'package:lovia/features/auth/data/models/auth_response_model.dart';
import 'package:lovia/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lovia/features/auth/domain/entities/auth_provider.dart';
import 'package:lovia/features/auth/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements AuthRemoteDataSource {}

class MockLocal extends Mock implements AuthLocalDataSource {}

class MockSocial extends Mock implements AuthSocialDataSource {}

String makeToken(String userId, int exp) {
  String seg(Map<String, dynamic> m) =>
      base64Url.encode(utf8.encode(jsonEncode(m))).replaceAll('=', '');
  final header = seg({'alg': 'HS256', 'typ': 'JWT'});
  final payload = seg({'userId': userId, 'exp': exp});
  return '$header.$payload.signature';
}

AuthResponseModel authResponse({
  required String id,
  required String name,
  String? email,
  bool isGuest = false,
}) {
  return AuthResponseModel(
    accessToken: makeToken(id, 9999999999),
    refreshToken: 'refresh-$id',
    user: UserModel(id: id, name: name, email: email, isGuest: isGuest),
  );
}

void main() {
  late MockRemote remote;
  late MockLocal local;
  late MockSocial social;
  late AuthRepositoryImpl repo;

  final futureExp =
      DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000;

  // Default stub for the (large) cacheSession signature.
  void stubCache() {
    when(() => local.cacheSession(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
          name: any(named: 'name'),
          email: any(named: 'email'),
          userId: any(named: 'userId'),
          avatarUrl: any(named: 'avatarUrl'),
          isGuest: any(named: 'isGuest'),
        )).thenAnswer((_) async {});
  }

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    social = MockSocial();
    repo = AuthRepositoryImpl(remote: remote, local: local, social: social);
  });

  group('login', () {
    test('on success caches the session and returns the backend user',
        () async {
      when(() => remote.login(email: 'a@b.com', password: 'secret')).thenAnswer(
        (_) async => authResponse(id: '42', name: 'Aria', email: 'a@b.com'),
      );
      stubCache();

      final result = await repo.login(email: 'a@b.com', password: 'secret');

      expect(result, isA<Success<User, Failure>>());
      final user = (result as Success<User, Failure>).value;
      expect(user.id, '42');
      expect(user.name, 'Aria');
      expect(user.email, 'a@b.com');
      verify(() => local.cacheSession(
            accessToken: any(named: 'accessToken'),
            refreshToken: 'refresh-42',
            name: 'Aria',
            email: 'a@b.com',
            userId: '42',
            avatarUrl: any(named: 'avatarUrl'),
            isGuest: any(named: 'isGuest'),
          )).called(1);
    });

    test('maps NetworkException to NetworkFailure', () async {
      when(() => remote.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(const NetworkException());
      final result = await repo.login(email: 'a@b.com', password: 'x');
      expect((result as Failed).failure, isA<NetworkFailure>());
    });

    test('maps UnauthorizedException to UnauthorizedFailure', () async {
      when(() => remote.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(const UnauthorizedException());
      final result = await repo.login(email: 'a@b.com', password: 'x');
      expect((result as Failed).failure, isA<UnauthorizedFailure>());
    });

    test('maps a 4xx ServerException to ValidationFailure', () async {
      when(() => remote.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(const ServerException(code: 400, message: 'Invalid credentials'));
      final result = await repo.login(email: 'a@b.com', password: 'x');
      expect((result as Failed).failure, isA<ValidationFailure>());
    });

    test('maps a 5xx ServerException to ServerFailure', () async {
      when(() => remote.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(const ServerException(code: 500, message: 'Server error'));
      final result = await repo.login(email: 'a@b.com', password: 'x');
      expect((result as Failed).failure, isA<ServerFailure>());
    });

    test('maps an unexpected error to UnknownFailure', () async {
      when(() => remote.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(Exception('boom'));
      final result = await repo.login(email: 'a@b.com', password: 'x');
      expect((result as Failed).failure, isA<UnknownFailure>());
    });
  });

  group('checkAuthStatus', () {
    test('returns the cached user when the token is valid', () async {
      final token = makeToken('7', futureExp);
      when(() => local.readToken()).thenAnswer((_) async => token);
      when(() => local.readUserId()).thenAnswer((_) async => '7');
      when(() => local.readName()).thenAnswer((_) async => 'Kai');
      when(() => local.readEmail()).thenAnswer((_) async => 'k@b.com');
      when(() => local.readAvatar()).thenAnswer((_) async => null);
      when(() => local.readIsGuest()).thenAnswer((_) async => false);

      final result = await repo.checkAuthStatus();

      final user = (result as Success<User, Failure>).value;
      expect(user.id, '7');
      expect(user.name, 'Kai');
    });

    test('clears storage and fails when expired with no refresh token',
        () async {
      final expired = makeToken('7', 1);
      when(() => local.readToken()).thenAnswer((_) async => expired);
      when(() => local.readRefreshToken()).thenAnswer((_) async => null);
      when(() => local.clear()).thenAnswer((_) async {});

      final result = await repo.checkAuthStatus();

      expect((result as Failed).failure, isA<UnauthorizedFailure>());
      verify(() => local.clear()).called(1);
    });

    test('maps a CacheException to CacheFailure', () async {
      when(() => local.readToken()).thenThrow(const CacheException());
      final result = await repo.checkAuthStatus();
      expect((result as Failed).failure, isA<CacheFailure>());
    });
  });

  group('logout', () {
    test('clears local storage and returns Unit', () async {
      when(() => remote.logout()).thenAnswer((_) async {});
      when(() => social.signOut()).thenAnswer((_) async {});
      when(() => local.clear()).thenAnswer((_) async {});
      final result = await repo.logout();
      expect(result, isA<Success<Unit, Failure>>());
      verify(() => local.clear()).called(1);
    });
  });

  group('guest + social', () {
    test('loginAsGuest exchanges the device id and returns a Guest user',
        () async {
      when(() => local.deviceId()).thenAnswer((_) async => 'device-xyz');
      when(() => remote.guest(deviceId: 'device-xyz')).thenAnswer(
        (_) async => authResponse(id: 'guest-1', name: 'Guest', isGuest: true),
      );
      stubCache();

      final result = await repo.loginAsGuest();

      final user = (result as Success<User, Failure>).value;
      expect(user.name, 'Guest');
      expect(user.isGuest, isTrue);
    });

    test('loginAsGuest falls back to an offline guest when the network fails',
        () async {
      when(() => local.deviceId()).thenAnswer((_) async => 'device-xyz');
      when(() => remote.guest(deviceId: any(named: 'deviceId')))
          .thenThrow(const NetworkException());
      stubCache();
      when(() => local.readToken()).thenAnswer((_) async => 'lovia-offline-guest');
      when(() => local.readUserId()).thenAnswer((_) async => 'guest-1');
      when(() => local.readName()).thenAnswer((_) async => 'Guest');
      when(() => local.readEmail()).thenAnswer((_) async => '');
      when(() => local.readAvatar()).thenAnswer((_) async => null);
      when(() => local.readIsGuest()).thenAnswer((_) async => true);

      final result = await repo.loginAsGuest();

      final user = (result as Success<User, Failure>).value;
      expect(user.name, 'Guest');
      expect(user.isGuest, isTrue);
    });

    test('signInWithProvider exchanges the Google id token', () async {
      when(() => social.signIn(AuthProvider.google)).thenAnswer(
        (_) async => const SocialCredential(
          provider: AuthProvider.google,
          idToken: 'google-id-token',
        ),
      );
      when(() => remote.google(idToken: 'google-id-token')).thenAnswer(
        (_) async => authResponse(id: 'g-1', name: 'Sol', email: 's@b.com'),
      );
      stubCache();

      final result = await repo.signInWithProvider(AuthProvider.google);

      final user = (result as Success<User, Failure>).value;
      expect(user.id, 'g-1');
      expect(user.name, 'Sol');
    });
  });
}
