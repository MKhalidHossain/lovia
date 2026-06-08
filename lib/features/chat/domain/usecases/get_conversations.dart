import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/chat/domain/entities/conversation.dart';
import 'package:lovia/features/chat/domain/repositories/chat_repository.dart';

class GetConversations implements UseCase<List<Conversation>, NoParams> {
  const GetConversations(this._repository);
  final ChatRepository _repository;

  @override
  Future<Result<List<Conversation>, Failure>> call(NoParams params) {
    return _repository.getConversations();
  }
}
