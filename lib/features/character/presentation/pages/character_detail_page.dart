import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/app_scaffold.dart';
import 'package:lovia/core/widgets/gradient_button.dart';
import 'package:lovia/core/widgets/view_state_view.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/character/presentation/controllers/character_detail_controller.dart';
import 'package:lovia/features/character/presentation/widgets/character_avatar.dart';

class CharacterDetailPage extends GetView<CharacterDetailController> {
  const CharacterDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(),
      body: Obx(
        () => ViewStateView<Character>(
          state: controller.state.value,
          onRetry: () {
            final id = Get.arguments as String?;
            if (id != null) controller.load(id);
          },
          builder: (context, character) => _Detail(character),
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail(this.character);
  final Character character;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Hero(
              tag: 'character-${character.id}',
              child: CharacterAvatar(
                character: character,
                size: 160,
                radius: AppRadii.xl,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(character.name, style: theme.textTheme.displayMedium),
              ),
              Chip(label: Text('Age ${character.age}')),
            ],
          ),
          Text(character.category, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          Text(character.bio, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.lg),
          Text('Traits', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final t in character.traits) Chip(label: Text(t)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Backstory', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(character.backstory, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          Text('Tone', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(character.tone, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          GradientButton(
            label: 'Start chat',
            icon: Icons.chat_bubble_rounded,
            onPressed: () => Get.toNamed<void>(
              AppRoutes.chat,
              arguments: character,
            ),
          ),
        ],
      ),
    );
  }
}
