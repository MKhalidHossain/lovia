import 'package:json_annotation/json_annotation.dart';
import 'package:lovia/features/chat/data/models/chat_message_model.dart';
import 'package:lovia/features/chat/domain/entities/conversation.dart';

part 'conversation_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ConversationModel {
  const ConversationModel({
    required this.characterId,
    required this.characterName,
    required this.messages,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  final String characterId;
  final String characterName;
  final List<ChatMessageModel> messages;

  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);

  Conversation toEntity() => Conversation(
        characterId: characterId,
        characterName: characterName,
        messages: messages.map((m) => m.toEntity()).toList(),
      );
}
