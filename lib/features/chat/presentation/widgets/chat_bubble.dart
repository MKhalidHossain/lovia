import 'package:flutter/material.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/features/chat/domain/entities/chat_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({required this.message, super.key});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.isUser;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(AppRadii.lg),
      topRight: const Radius.circular(AppRadii.lg),
      bottomLeft: Radius.circular(isUser ? AppRadii.lg : AppRadii.xs),
      bottomRight: Radius.circular(isUser ? AppRadii.xs : AppRadii.lg),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        decoration: BoxDecoration(
          gradient: isUser ? AppColors.brandGradient : null,
          color: isUser ? null : theme.colorScheme.surfaceContainerHighest,
          borderRadius: radius,
        ),
        child: Text(
          message.text,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isUser ? Colors.white : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
