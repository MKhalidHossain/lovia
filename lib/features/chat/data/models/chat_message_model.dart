import 'package:json_annotation/json_annotation.dart';
import 'package:lovia/features/chat/domain/entities/chat_message.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessageModel {
  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.isUser,
    required this.sentAtMs,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  factory ChatMessageModel.fromEntity(ChatMessage m) => ChatMessageModel(
        id: m.id,
        text: m.text,
        isUser: m.isUser,
        sentAtMs: m.sentAt.millisecondsSinceEpoch,
      );

  final String id;
  final String text;
  final bool isUser;
  final int sentAtMs;

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  ChatMessage toEntity() => ChatMessage(
        id: id,
        text: text,
        isUser: isUser,
        sentAt: DateTime.fromMillisecondsSinceEpoch(sentAtMs),
      );
}
