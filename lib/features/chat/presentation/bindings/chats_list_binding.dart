import 'package:get/get.dart';
import 'package:lovia/features/character/domain/repositories/character_repository.dart';
import 'package:lovia/features/character/domain/usecases/get_character_by_id.dart';
import 'package:lovia/features/chat/domain/repositories/chat_repository.dart';
import 'package:lovia/features/chat/domain/usecases/get_conversations.dart';
import 'package:lovia/features/chat/presentation/controllers/chats_list_controller.dart';

class ChatsListBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut(() => GetConversations(Get.find<ChatRepository>()))
      ..lazyPut<GetCharacterById>(
        () => GetCharacterById(Get.find<CharacterRepository>()),
        fenix: true,
      )
      ..lazyPut(
        () => ChatsListController(
          getConversations: Get.find(),
          getCharacterById: Get.find(),
        ),
      );
  }
}
