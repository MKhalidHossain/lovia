import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/features/chat/domain/entities/chat_message.dart';
import 'package:lovia/features/chat/domain/entities/conversation.dart';

abstract interface class ChatRepository {

  Future<Result<Conversation, Failure>> getConversation({
    required String characterId,
    required String characterName,
  });

  Future<Result<List<Conversation>, Failure>> getConversations();

  Future<Result<Conversation, Failure>> sendMessage({
    required String characterId,
    required String characterName,
    required ChatMessage message,
  });

  Future<Result<ChatMessage, Failure>> generateReply({
    required String characterId,
    required String characterName,
    required String userText,
  });
}
