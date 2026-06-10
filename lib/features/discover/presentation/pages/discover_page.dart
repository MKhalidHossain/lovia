import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/state/view_state.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/empty_state.dart';
import 'package:lovia/core/widgets/error_state.dart';
import 'package:lovia/core/widgets/gem_badge.dart';
import 'package:lovia/core/widgets/loading_shimmer.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/character/presentation/widgets/character_tile.dart';
import 'package:lovia/features/discover/presentation/controllers/discover_controller.dart';
import 'package:lovia/features/discover/presentation/widgets/filter_sheet.dart';

class DiscoverPage extends GetView<DiscoverController> {
  const DiscoverPage({super.key});

  void _openCharacter(Character c) {
    Get.toNamed<void>(AppRoutes.characterDetail, arguments: c.id);
  }

  void _openFilter() {
    final styles = controller.categories;
    Get.bottomSheet<void>(
      FilterSheet(
        genders: const ['Male', 'Female', 'Non-binary'],
        styles: styles,
        initialGender: controller.genderFilter.value,
        initialAge: controller.ageFilter.value,
        initialStyle: controller.selectedCategory.value,
        onApply: (gender, age, style) {
          controller
            ..selectCategory(style)
            ..applyFilters(gender: gender, age: age);
        },
        onReset: controller.resetFilters,
      ),
      isScrollControlled: true,
      backgroundColor: Get.theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xs,
          ),
          child: Row(
            children: [
              Text('Discover', style: theme.textTheme.displayMedium),
              const Spacer(),
              const GemBadge(),
              IconButton(
                onPressed: () => Get.toNamed<void>(AppRoutes.search),
                icon: const Icon(Icons.search_rounded),
              ),
            ],
          ),
        ),
        _CategoryChips(onFilter: _openFilter),
        Expanded(
          child: Obx(() {
            final state = controller.state.value;
            return switch (state) {
              ViewLoaded<List<Character>>() => RefreshIndicator(
                  onRefresh: controller.load,
                  child: _Grid(items: controller.visible, onTap: _openCharacter),
                ),
              ViewError<List<Character>>(:final message) =>
                ErrorState(message: message, onRetry: controller.load),
              _ => const _GridSkeleton(),
            };
          }),
        ),
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.onFilter});
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DiscoverController>();
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              // Subscribe to state so the chips refresh once characters load,
              // since `categories` is derived from the loaded list.
              controller.state.value;
              final selected = controller.selectedCategory.value;
              final categories = controller.categories;
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
                itemBuilder: (context, i) {
                  final cat = categories[i];
                  return ChoiceChip(
                    label: Text(cat),
                    selected: selected == cat,
                    onSelected: (_) => controller.selectCategory(cat),
                  );
                },
              );
            }),
          ),
          Obx(
            () => IconButton(
              onPressed: onFilter,
              icon: Icon(
                Icons.tune_rounded,
                color: controller.hasActiveFilters
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.items, required this.onTap});
  final List<Character> items;
  final void Function(Character) onTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
          const EmptyState(message: 'No characters match your filters.'),
        ],
      );
    }
    // Simple two-column masonry with alternating heights, no extra deps.
    final left = <Widget>[];
    final right = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final height = i.isEven ? 250.0 : 200.0;
      final tile = Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: CharacterTile(
          character: items[i],
          height: height,
          onTap: () => onTap(items[i]),
        ),
      );
      (i.isEven ? left : right).add(tile);
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Column(children: left)),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Column(children: right)),
          ],
        ),
      ],
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(AppSpacing.lg),
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 0.7,
      children: List.generate(
        6,
        (_) => const LoadingShimmer(radius: AppRadii.lg),
      ),
    );
  }
}
