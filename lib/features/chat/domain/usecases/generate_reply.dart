import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/chat/domain/entities/chat_message.dart';
import 'package:lovia/features/chat/domain/repositories/chat_repository.dart';

class GenerateReplyParams {
  const GenerateReplyParams({
    required this.characterId,
    required this.characterName,
    required this.userText,
  });
  final String characterId;
  final String characterName;
  final String userText;
}

class GenerateReply implements UseCase<ChatMessage, GenerateReplyParams> {
  const GenerateReply(this._repository);
  final ChatRepository _repository;

  @override
  Future<Result<ChatMessage, Failure>> call(GenerateReplyParams params) {
    return _repository.generateReply(
      characterId: params.characterId,
      characterName: params.characterName,
      userText: params.userText,
    );
  }
}
