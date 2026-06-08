import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  static const List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.explore_outlined),
      activeIcon: Icon(Icons.explore_rounded),
      label: 'Discover',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_circle_outline_rounded),
      activeIcon: Icon(Icons.add_circle_rounded),
      label: 'Create',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_bubble_outline_rounded),
      activeIcon: Icon(Icons.chat_bubble_rounded),
      label: 'Chats',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline_rounded),
      activeIcon: Icon(Icons.person_rounded),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        body: IndexedStack(index: controller.index.value, children: _tabs),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.index.value,
          onTap: (i) => controller.index.value = i,
          items: _items,
        ),
      ),
    );
  }
}
