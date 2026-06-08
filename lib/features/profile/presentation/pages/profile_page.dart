import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/state/view_state.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/theme/theme_controller.dart';
import 'package:lovia/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/character/presentation/widgets/character_avatar.dart';
import 'package:lovia/features/profile/presentation/controllers/profile_controller.dart';
import 'package:lovia/features/wallet/presentation/controllers/wallet_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  void _showMyCharacters(BuildContext context) {
    controller.loadMine();
    Get.bottomSheet<void>(
      _MyCharactersSheet(controller: controller),
      backgroundColor: Get.theme.colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Get.find<AuthController>();
    final wallet = Get.find<WalletController>();
    final themeController = Get.find<ThemeController>();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Obx(() {
          final user = auth.currentUser;
          return Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.brandGradient,
                ),
                child: Center(
                  child: Text(
                    (user?.name.isNotEmpty ?? false)
                        ? user!.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.name ?? 'Guest', style: theme.textTheme.titleLarge),
                  Text(
                    'Id : ${_shortId(user?.id)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          );
        }),
        const SizedBox(height: AppSpacing.lg),
        _PremiumCard(onTap: () => Get.toNamed<void>(AppRoutes.topUp)),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _MiniCard(
                title: 'My wallet',
                subtitle: Obx(
                  () => Row(
                    children: [
                      const Icon(Icons.public_rounded,
                          color: Color(0xFF5FB7FF), size: 18),
                      const SizedBox(width: 4),
                      Text('${wallet.balance}',
                          style: theme.textTheme.titleMedium),
                    ],
                  ),
                ),
                icon: Icons.refresh_rounded,
                onTap: () => Get.toNamed<void>(AppRoutes.topUp),
                onIcon: wallet.load,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _MiniCard(
                title: 'Daily task',
                subtitle: Text('Get more coin', style: theme.textTheme.bodyMedium),
                icon: Icons.chevron_right_rounded,
                onTap: () => Get.toNamed<void>(AppRoutes.dailyTask),
                onIcon: () => Get.toNamed<void>(AppRoutes.dailyTask),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _CommunityBanner(),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Column(
            children: [
              _Row(
                icon: Icons.auto_awesome_rounded,
                label: 'My character',
                onTap: () => _showMyCharacters(context),
              ),
              const Divider(height: 1),
              _Row(
                icon: Icons.language_rounded,
                label: 'Language',
                trailing: 'English',
                onTap: () => Get.toNamed<void>(AppRoutes.language),
              ),
              const Divider(height: 1),
              Obx(
                () => SwitchListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  secondary: const Icon(Icons.dark_mode_rounded),
                  title: const Text('Dark mode'),
                  value: themeController.isDark,
                  onChanged: (v) => themeController.toggleDark(dark: v),
                ),
              ),
              const Divider(height: 1),
              _Row(
                icon: Icons.star_rounded,
                label: 'Rate app',
                onTap: () => Get.snackbar('Thanks!', 'Rating is a demo here.'),
              ),
              const Divider(height: 1),
              _Row(
                icon: Icons.share_rounded,
                label: 'Share',
                onTap: () => Get.snackbar('Share', 'Sharing is a demo here.'),
              ),
              const Divider(height: 1),
              _Row(
                icon: Icons.mail_outline_rounded,
                label: 'Feedback',
                onTap: () => Get.snackbar('Feedback', 'Thanks for the feedback!'),
              ),
              const Divider(height: 1),
              _Row(
                icon: Icons.description_outlined,
                label: 'Term of Service',
                onTap: () => Get.snackbar('Terms', 'Opens Terms of Service.'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          onPressed: auth.logout,
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Sign out'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error),
          ),
        ),
      ],
    );
  }

  String _shortId(String? id) {
    if (id == null || id.isEmpty) return '0000000';
    final digits = id.hashCode.toUnsigned(32) % 10000000;
    return digits.toString().padLeft(7, '0');
  }
}

class _PremiumCard extends StatelessWidget {
  const _PremiumCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFE2B8), Color(0xFFF6C77A)],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lovia AI Premium',
                    style: TextStyle(
                      color: Color(0xFF7A4B00),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Claim 🌐 1000',
                      style: TextStyle(color: Color(0xFF5A3A10))),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                    child: const Text(
                      'Subscribe now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.workspace_premium_rounded,
                size: 56, color: Color(0xFF7A4B00)),
          ],
        ),
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.onIcon,
  });

  final String title;
  final Widget subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 96,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                GestureDetector(onTap: onIcon, child: Icon(icon, size: 20)),
              ],
            ),
            const Spacer(),
            subtitle,
          ],
        ),
      ),
    );
  }
}

class _CommunityBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        gradient: const LinearGradient(
          colors: [Color(0xFF6C4BD8), Color(0xFFB14BD8)],
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.discord, color: Colors.white),
              SizedBox(width: AppSpacing.xs),
              Text('Join our community',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(trailing!,
                style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _MyCharactersSheet extends StatelessWidget {
  const _MyCharactersSheet({required this.controller});
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My characters', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          Obx(() {
            final state = controller.myCharacters.value;
            return switch (state) {
              ViewLoaded<List<Character>>(:final data) when data.isEmpty =>
                Text("You haven't created any characters yet.",
                    style: theme.textTheme.bodyMedium),
              ViewLoaded<List<Character>>(:final data) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final c in data)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CharacterAvatar(
                            character: c, size: 44, radius: 12),
                        title: Text(c.name),
                        subtitle: Text(c.bio,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        onTap: () {
                          Get
                            ..back<void>()
                            ..toNamed<void>(
                              AppRoutes.characterDetail,
                              arguments: c.id,
                            );
                        },
                      ),
                  ],
                ),
              ViewError<List<Character>>(:final message) =>
                Text(message, style: theme.textTheme.bodyMedium),
              _ => const Center(child: CircularProgressIndicator()),
            };
          }),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
