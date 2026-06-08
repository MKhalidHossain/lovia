import 'package:get/get.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/state/view_state.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/character/domain/usecases/get_character_by_id.dart';
import 'package:lovia/features/chat/domain/entities/conversation.dart';
import 'package:lovia/features/chat/domain/usecases/get_conversations.dart';

class ChatsListController extends GetxController {
  ChatsListController({
    required GetConversations getConversations,
    required GetCharacterById getCharacterById,
  })  : _getConversations = getConversations,
        _getCharacterById = getCharacterById;

  final GetConversations _getConversations;
  final GetCharacterById _getCharacterById;

  final Rx<ViewState<List<Conversation>>> state =
      const ViewState<List<Conversation>>.initial().obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    state.value = const ViewState<List<Conversation>>.loading();
    final result = await _getConversations(const NoParams());
    state.value = switch (result) {
      Success(:final value) => ViewState<List<Conversation>>.loaded(value),
      Failed(:final failure) =>
        ViewState<List<Conversation>>.error(failure.message),
    };
  }

  Future<void> openConversation(String characterId) async {
    final result = await _getCharacterById(characterId);
    if (result case Success(:final value)) {
      await Get.toNamed<void>(AppRoutes.chat, arguments: value);
      await load();
    }
  }
}
