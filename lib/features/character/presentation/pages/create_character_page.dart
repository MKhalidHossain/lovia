import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/gradient_button.dart';
import 'package:lovia/features/character/presentation/controllers/create_character_controller.dart';

class CreateCharacterPage extends GetView<CreateCharacterController> {
  const CreateCharacterPage({super.key});

  Future<void> _submit() async {
    final created = await controller.submit();
    if (created != null) {
      Get.snackbar('Character created', '${created.name} is ready to chat.');
      await Get.toNamed<void>(
        AppRoutes.characterDetail,
        arguments: created.id,
      );
    }
  }

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
            0,
          ),
          child: Row(
            children: [
              Text('Create character', style: theme.textTheme.headlineMedium),
              const Spacer(),
              TextButton.icon(
                onPressed: controller.randomFill,
                icon: const Icon(Icons.auto_awesome_rounded,
                    color: AppColors.amber, size: 18),
                label: const Text('Random AI'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _Field(
                label: 'Character name',
                required: true,
                controller: controller.nameCtrl,
                hint: 'Name',
                maxLength: 50,
                onChanged: (v) => controller.name.value = v,
              ),
              _Field(
                label: 'Age',
                required: true,
                controller: controller.ageCtrl,
                hint: 'Age (18+)',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => controller.name.refresh(),
              ),
              Text('Gender',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpacing.xs),
              Obx(
                () => Wrap(
                  spacing: AppSpacing.xs,
                  children: [
                    for (final g in CreateCharacterController.genderOptions)
                      ChoiceChip(
                        label: Text(g),
                        selected: controller.gender.value == g,
                        onSelected: (_) => controller.gender.value = g,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _Field(
                label: 'Introduction',
                controller: controller.introCtrl,
                hint: 'e.g long blonde hair, blue eyes',
                maxLength: 2000,
                maxLines: 3,
              ),
              _Field(
                label: 'Personality',
                controller: controller.personalityCtrl,
                hint: 'e.g. Playful, flirty, sometimes shy',
                maxLength: 2000,
                maxLines: 3,
              ),
              _Field(
                label: 'Language Characteristics',
                controller: controller.languageCtrl,
                hint: 'e.g. Casual, uses emojis, sweet & teasing',
                maxLength: 2000,
                maxLines: 3,
              ),
              _Field(
                label: 'Character Relationship',
                controller: controller.relationshipCtrl,
                hint: 'e.g. Acts like best friend but also flirts sometimes',
                maxLength: 2000,
                maxLines: 3,
              ),
              _Field(
                label: 'Preview',
                controller: controller.previewCtrl,
                hint: 'e.g. First impression of the character in 1–2 lines',
                maxLength: 2000,
                maxLines: 2,
              ),
              Text('Category',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpacing.xs),
              Obx(
                () => Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final c in CreateCharacterController.categoryOptions)
                      ChoiceChip(
                        label: Text(c),
                        selected: controller.category.value == c,
                        onSelected: (_) => controller.category.value = c,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Obx(
                () => Text(
                  'Tag * (${controller.tags.length}/'
                  '${CreateCharacterController.maxTags})',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Obx(
                () => Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final t in CreateCharacterController.tagOptions)
                      FilterChip(
                        label: Text(t),
                        selected: controller.tags.contains(t),
                        onSelected: (_) => controller.toggleTag(t),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Obx(
            () => GradientButton(
              label: 'Continue',
              isLoading: controller.isSaving.value,
              onPressed: controller.canSubmit ? _submit : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.hint,
    this.required = false,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final bool required;
  final int? maxLength;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: label,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
              children: [
                if (required)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppColors.rose),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: controller,
            maxLength: maxLength,
            maxLines: maxLines,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
}
