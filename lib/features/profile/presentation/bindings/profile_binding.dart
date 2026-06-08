import 'package:get/get.dart';
import 'package:lovia/features/character/domain/repositories/character_repository.dart';
import 'package:lovia/features/character/domain/usecases/get_my_characters.dart';
import 'package:lovia/features/profile/presentation/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut(() => GetMyCharacters(Get.find<CharacterRepository>()))
      ..lazyPut(() => ProfileController(Get.find()));
  }
}
