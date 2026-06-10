import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/widgets/app_scaffold.dart';
import 'package:lovia/features/character/presentation/pages/create_character_page.dart';
import 'package:lovia/features/chat/presentation/pages/chats_list_page.dart';
import 'package:lovia/features/discover/presentation/pages/discover_page.dart';
import 'package:lovia/features/home/presentation/pages/home_page.dart';
import 'package:lovia/features/profile/presentation/pages/profile_page.dart';
import 'package:lovia/features/shell/presentation/controllers/shell_controller.dart';

class ShellPage extends GetView<ShellController> {
  const ShellPage({super.key});

  static const List<Widget> _tabs = [
    HomePage(),
    DiscoverPage(),
    CreateCharacterPage(),
    ChatsListPage(),
    ProfilePage(),
  ];

  static const List<IconData> _icons = [
    Icons.home_outlined,
    Icons.explore_outlined,
    Icons.add_box_outlined,
    Icons.chat_bubble_outline_rounded,
    Icons.person_outline_rounded,
  ];

  static const List<String> _labels = [
    'Home',
    'Discover',
    'Create',
    'Chats',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        body: IndexedStack(index: controller.index.value, children: _tabs),
        bottomNavigationBar: _LoviaNavBar(
          index: controller.index.value,
          onTap: (i) => controller.index.value = i,
        ),
      ),
    );
  }
}

/// Label-less nav: white outline icons with a small pink underline dash
/// beneath the active item, over the dark base.
class _LoviaNavBar extends StatelessWidget {
  const _LoviaNavBar({required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.darkBase,
        border: Border(top: BorderSide(color: AppColors.darkHairline)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              for (var i = 0; i < ShellPage._icons.length; i++)
                Expanded(
                  child: _NavItem(
                    icon: ShellPage._icons[i],
                    label: ShellPage._labels[i],
                    selected: i == index,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : Colors.white70;
    return InkWell(
      onTap: onTap,
      customBorder: const StadiumBorder(),
      child: Semantics(
        label: label,
        selected: selected,
        button: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: selected ? 18 : 0,
              decoration: const BoxDecoration(
                color: AppColors.accentPink,
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
