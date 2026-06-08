import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/empty_state.dart';
import 'package:lovia/core/widgets/gem_badge.dart';
import 'package:lovia/core/widgets/view_state_view.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/home/presentation/controllers/home_controller.dart';
import 'package:lovia/features/home/presentation/widgets/swipe_deck.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('For you', style: theme.textTheme.displayMedium),
              const GemBadge(),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Obx(
              () => ViewStateView<List<Character>>(
                state: controller.state.value,
                onRetry: controller.load,
                builder: (context, _) {
                  final current = controller.current;
                  if (current == null) {
                    return EmptyState(
                      icon: Icons.favorite_border_rounded,
                      message: "You're all caught up for now.",
                      actionLabel: 'Start over',
                      onAction: controller.restart,
                    );
                  }
                  return SwipeDeck(
                    key: ValueKey(current.id),
                    current: current,
                    peek: controller.peek,
                    onPass: controller.pass,
                    onLike: controller.like,
                    onChat: () => Get.toNamed<void>(
                      AppRoutes.chat,
                      arguments: current,
                    ),
                    onOpen: () => Get.toNamed<void>(
                      AppRoutes.characterDetail,
                      arguments: current.id,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
