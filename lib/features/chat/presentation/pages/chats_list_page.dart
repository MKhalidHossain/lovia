import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/empty_state.dart';
import 'package:lovia/core/widgets/view_state_view.dart';
import 'package:lovia/features/chat/domain/entities/conversation.dart';
import 'package:lovia/features/chat/presentation/controllers/chats_list_controller.dart';

class ChatsListPage extends GetView<ChatsListController> {
  const ChatsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: Text('Chats', style: theme.textTheme.displayMedium),
        ),
        Expanded(
          child: Obx(
            () => ViewStateView<List<Conversation>>(
              state: controller.state.value,
              onRetry: controller.load,
              builder: (context, conversations) {
                if (conversations.isEmpty) {
                  return const EmptyState(
                    icon: Icons.forum_outlined,
                    message: 'No conversations yet.\nStart chatting from a '
                        "character's profile.",
                  );
                }
                return RefreshIndicator(
                  onRefresh: controller.load,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    itemCount: conversations.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final c = conversations[i];
                      final last = c.messages.isEmpty ? '' : c.messages.last.text;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          child: Text(
                            c.characterName.isEmpty ? '?' : c.characterName[0],
                          ),
                        ),
                        title: Text(c.characterName),
                        subtitle: Text(
                          last,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => controller.openConversation(c.characterId),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
