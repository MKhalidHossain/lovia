import 'package:lovia/core/error/exceptions.dart';
import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:lovia/features/chat/data/models/chat_message_model.dart';
import 'package:lovia/features/chat/domain/entities/chat_message.dart';
import 'package:lovia/features/chat/domain/entities/conversation.dart';
import 'package:lovia/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._local);
  final ChatLocalDataSource _local;

  @override
  Future<Result<Conversation, Failure>> getConversation({
    required String characterId,
    required String characterName,
  }) {
    return _guard(
      () async =>
          _local.getConversation(characterId, characterName).toEntity(),
    );
  }

  @override
  Future<Result<List<Conversation>, Failure>> getConversations() {
    return _guard(
      () async => _local.getConversations().map((c) => c.toEntity()).toList(),
    );
  }

  @override
  Future<Result<Conversation, Failure>> sendMessage({
    required String characterId,
    required String characterName,
    required ChatMessage message,
  }) {
    return _guard(
      () async => _local
          .append(characterId, characterName, ChatMessageModel.fromEntity(message))
          .toEntity(),
    );
  }

  @override
  Future<Result<ChatMessage, Failure>> generateReply({
    required String characterId,
    required String characterName,
    required String userText,
  }) {
    return _guard(() async {
      final reply = _local.buildReply(userText);
      _local.append(characterId, characterName, reply);
      return reply.toEntity();
    });
  }

  Future<Result<T, Failure>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on CacheException catch (e) {
      return Failed(CacheFailure(e.message));
    } on Object catch (e) {
      return Failed(UnknownFailure('Unexpected error: $e'));
    }
  }
}
