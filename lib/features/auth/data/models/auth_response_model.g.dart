// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    AuthResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

TokenPairModel _$TokenPairModelFromJson(Map<String, dynamic> json) =>
    TokenPairModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  coins: (json['coins'] as num?)?.toInt() ?? 0,
  isGuest: json['isGuest'] as bool? ?? false,
  language: json['language'] as String?,
);
