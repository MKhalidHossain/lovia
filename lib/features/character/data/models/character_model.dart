import 'package:json_annotation/json_annotation.dart';
import 'package:lovia/features/character/domain/entities/character.dart';

part 'character_model.g.dart';

@JsonSerializable()
class CharacterModel {
  const CharacterModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.category,
    required this.traits,
    required this.age,
    required this.backstory,
    required this.tone,
    required this.greeting,
    required this.accent,
    this.gender = 'Female',
    this.isMine = false,
    this.avatarUrl,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterModelFromJson(json);

  factory CharacterModel.fromEntity(Character c) => CharacterModel(
        id: c.id,
        name: c.name,
        bio: c.bio,
        category: c.category,
        traits: c.traits,
        age: c.age,
        backstory: c.backstory,
        tone: c.tone,
        greeting: c.greeting,
        accent: c.accent,
        gender: c.gender,
        isMine: c.isMine,
        avatarUrl: c.avatarUrl,
      );

  final String id;
  final String name;
  final String bio;
  final String category;
  final List<String> traits;
  final int age;
  final String backstory;
  final String tone;
  final String greeting;
  final int accent;
  final String gender;
  final bool isMine;
  final String? avatarUrl;

  Map<String, dynamic> toJson() => _$CharacterModelToJson(this);

  Character toEntity() => Character(
        id: id,
        name: name,
        bio: bio,
        category: category,
        traits: traits,
        age: age,
        backstory: backstory,
        tone: tone,
        greeting: greeting,
        accent: accent,
        gender: gender,
        isMine: isMine,
        avatarUrl: avatarUrl,
      );
}
