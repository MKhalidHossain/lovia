import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/chat/domain/entities/conversation.dart';
import 'package:lovia/features/chat/domain/repositories/chat_repository.dart';

class ConversationParams {
  const ConversationParams({required this.characterId, required this.characterName});
  final String characterId;
  final String characterName;
}

class GetConversation implements UseCase<Conversation, ConversationParams> {
  const GetConversation(this._repository);
  final ChatRepository _repository;

  @override
  Future<Result<Conversation, Failure>> call(ConversationParams params) {
    return _repository.getConversation(
      characterId: params.characterId,
      characterName: params.characterName,
    );
  }
}
