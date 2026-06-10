import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    String? avatarUrl,
    @Default(0) int coins,
    @Default(false) bool isGuest,
    String? language,
  }) = _User;
}
