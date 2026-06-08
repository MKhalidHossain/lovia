import 'package:get/get.dart';
import 'package:lovia/core/constants/app_durations.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/chat/domain/entities/chat_message.dart';
import 'package:lovia/features/chat/domain/usecases/generate_reply.dart';
import 'package:lovia/features/chat/domain/usecases/get_conversation.dart';
import 'package:lovia/features/chat/domain/usecases/send_message.dart';

class ChatController extends GetxController {
  ChatController({
    required GetConversation getConversation,
    required SendMessage sendMessage,
    required GenerateReply generateReply,
  })  : _getConversation = getConversation,
        _sendMessage = sendMessage,
        _generateReply = generateReply;

  final GetConversation _getConversation;
  final SendMessage _sendMessage;
  final GenerateReply _generateReply;

  late final Character character = Get.arguments as Character;

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isTyping = false.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    final result = await _getConversation(
      ConversationParams(
        characterId: character.id,
        characterName: character.name,
      ),
    );
    if (result case Success(:final value)) {
      messages.assignAll(value.messages);
    }

    if (messages.isEmpty) {
      messages.add(
        ChatMessage(
          id: 'greeting-${character.id}',
          text: character.greeting,
          isUser: false,
          sentAt: DateTime.now(),
        ),
      );
    }
    isLoading.value = false;
  }

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || isTyping.value) return;

    final userMessage = ChatMessage(
      id: 'u-${DateTime.now().microsecondsSinceEpoch}',
      text: trimmed,
      isUser: true,
      sentAt: DateTime.now(),
    );

    messages.add(userMessage);
    await _sendMessage(
      SendMessageParams(
        characterId: character.id,
        characterName: character.name,
        message: userMessage,
      ),
    );

    isTyping.value = true;
    await Future<void>.delayed(AppDurations.typingDelay);
    final reply = await _generateReply(
      GenerateReplyParams(
        characterId: character.id,
        characterName: character.name,
        userText: trimmed,
      ),
    );
    isTyping.value = false;
    if (reply case Success(:final value)) {
      messages.add(value);
    }
  }
}
