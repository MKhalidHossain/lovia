import 'package:get/get.dart';
import 'package:lovia/features/character/presentation/bindings/create_character_binding.dart';
import 'package:lovia/features/chat/presentation/bindings/chats_list_binding.dart';
import 'package:lovia/features/discover/presentation/bindings/discover_binding.dart';
import 'package:lovia/features/home/presentation/bindings/home_binding.dart';
import 'package:lovia/features/profile/presentation/bindings/profile_binding.dart';
import 'package:lovia/features/shell/presentation/controllers/shell_controller.dart';

class ShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShellController());
    HomeBinding().dependencies();
    DiscoverBinding().dependencies();
    CreateCharacterBinding().dependencies();
    ChatsListBinding().dependencies();
    ProfileBinding().dependencies();
  }
}
