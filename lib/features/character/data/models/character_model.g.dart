// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterModel _$CharacterModelFromJson(Map<String, dynamic> json) =>
    CharacterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      bio: json['bio'] as String,
      category: json['category'] as String,
      traits: (json['traits'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      age: (json['age'] as num).toInt(),
      backstory: json['backstory'] as String,
      tone: json['tone'] as String,
      greeting: json['greeting'] as String,
      accent: (json['accent'] as num).toInt(),
      gender: json['gender'] as String? ?? 'Female',
      isMine: json['isMine'] as bool? ?? false,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$CharacterModelToJson(CharacterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bio': instance.bio,
      'category': instance.category,
      'traits': instance.traits,
      'age': instance.age,
      'backstory': instance.backstory,
      'tone': instance.tone,
      'greeting': instance.greeting,
      'accent': instance.accent,
      'gender': instance.gender,
      'isMine': instance.isMine,
      'avatarUrl': instance.avatarUrl,
    };
