import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/app_scaffold.dart';
import 'package:lovia/core/widgets/empty_state.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/character/presentation/widgets/character_tile.dart';
import 'package:lovia/features/discover/presentation/controllers/search_controller.dart';

class SearchPage extends GetView<CharacterSearchController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: TextField(
            autofocus: true,
            onChanged: controller.search,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              hintText: 'Search by character name, style',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = controller.results;
        if (items.isEmpty) {
          return const EmptyState(
            icon: Icons.search_off_rounded,
            message: 'No characters found. Try another search.',
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.68,
          ),
          itemCount: items.length,
          itemBuilder: (context, i) => CharacterTile(
            character: items[i],
            height: double.infinity,
            onTap: () => _open(items[i]),
          ),
        );
      }),
    );
  }

  void _open(Character c) =>
      Get.toNamed<void>(AppRoutes.characterDetail, arguments: c.id);
}
