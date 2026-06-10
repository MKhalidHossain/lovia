import 'package:json_annotation/json_annotation.dart';
import 'package:lovia/features/auth/domain/entities/user.dart';

part 'auth_response_model.g.dart';

/// Backend auth payload: `{ accessToken, refreshToken, user: {...} }`.
@JsonSerializable(createToJson: false)
class AuthResponseModel {
  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  final String accessToken;
  final String refreshToken;
  final UserModel user;
}

/// New access/refresh pair returned by `/auth/refresh`.
@JsonSerializable(createToJson: false)
class TokenPairModel {
  const TokenPairModel({required this.accessToken, required this.refreshToken});

  factory TokenPairModel.fromJson(Map<String, dynamic> json) =>
      _$TokenPairModelFromJson(json);

  final String accessToken;
  final String refreshToken;
}

/// User DTO returned by sign-in endpoints and `GET /users/me`.
@JsonSerializable(createToJson: false)
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
    this.coins = 0,
    this.isGuest = false,
    this.language,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  final String id;
  final String name;
  final String? email;
  final String? avatarUrl;
  final int coins;
  final bool isGuest;
  final String? language;

  User toEntity() => User(
        id: id,
        name: name,
        email: email ?? '',
        avatarUrl: avatarUrl,
        coins: coins,
        isGuest: isGuest,
        language: language,
      );
}
