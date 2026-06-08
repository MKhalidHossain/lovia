import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/chat/domain/entities/chat_message.dart';
import 'package:lovia/features/chat/domain/entities/conversation.dart';
import 'package:lovia/features/chat/domain/repositories/chat_repository.dart';

class SendMessageParams {
  const SendMessageParams({
    required this.characterId,
    required this.characterName,
    required this.message,
  });
  final String characterId;
  final String characterName;
  final ChatMessage message;
}

class SendMessage implements UseCase<Conversation, SendMessageParams> {
  const SendMessage(this._repository);
  final ChatRepository _repository;

  @override
  Future<Result<Conversation, Failure>> call(SendMessageParams params) {
    return _repository.sendMessage(
      characterId: params.characterId,
      characterName: params.characterName,
      message: params.message,
    );
  }
}
