import 'package:freezed_annotation/freezed_annotation.dart';

part 'character.freezed.dart';

@freezed
class Character with _$Character {
  const factory Character({
    required String id,
    required String name,
    required String bio,
    required String category,
    required List<String> traits,
    required int age,
    required String backstory,
    required String tone,
    required String greeting,
    required int accent,
    @Default('Female') String gender,
    @Default(false) bool isMine,
    String? avatarUrl,
  }) = _Character;
}
