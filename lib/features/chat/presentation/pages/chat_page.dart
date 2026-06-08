import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/app_scaffold.dart';
import 'package:lovia/features/character/presentation/widgets/character_avatar.dart';
import 'package:lovia/features/chat/presentation/controllers/chat_controller.dart';
import 'package:lovia/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:lovia/features/chat/presentation/widgets/typing_indicator.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController _controller = Get.find<ChatController>();
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();

    ever<List<dynamic>>(
      _controller.messages,
      (_) => _scrollToBottom(),
    );
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _send() {
    final text = _input.text;
    if (text.trim().isEmpty) return;
    _input.clear();
    _controller.send(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final character = _controller.character;
    return AppScaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CharacterAvatar(character: character, size: 38, radius: 12),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(character.name, style: theme.textTheme.titleMedium),
                Text(character.category, style: theme.textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final messages = _controller.messages;
              return ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                itemCount: messages.length + (_controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i >= messages.length) {
                    return const Align(
                      alignment: Alignment.centerLeft,
                      child: TypingIndicator(),
                    );
                  }
                  return ChatBubble(message: messages[i]);
                },
              );
            }),
          ),
          _InputBar(controller: _input, onSend: _send),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(hintText: 'Message…'),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            IconButton.filled(
              onPressed: onSend,
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                minimumSize: const Size(52, 52),
              ),
              icon: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
