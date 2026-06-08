import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lovia/features/chat/domain/entities/chat_message.dart';

part 'conversation.freezed.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required String characterId,
    required String characterName,
    required List<ChatMessage> messages,
  }) = _Conversation;
}
