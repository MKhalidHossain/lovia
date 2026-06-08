import 'package:get/get.dart';
import 'package:lovia/features/chat/domain/repositories/chat_repository.dart';
import 'package:lovia/features/chat/domain/usecases/generate_reply.dart';
import 'package:lovia/features/chat/domain/usecases/get_conversation.dart';
import 'package:lovia/features/chat/domain/usecases/send_message.dart';
import 'package:lovia/features/chat/presentation/controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    final repo = Get.find<ChatRepository>();
    Get
      ..lazyPut(() => GetConversation(repo))
      ..lazyPut(() => SendMessage(repo))
      ..lazyPut(() => GenerateReply(repo))
      ..lazyPut(
        () => ChatController(
          getConversation: Get.find(),
          sendMessage: Get.find(),
          generateReply: Get.find(),
        ),
      );
  }
}
