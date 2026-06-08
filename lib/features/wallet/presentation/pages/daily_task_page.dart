import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/state/view_state.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/app_scaffold.dart';
import 'package:lovia/features/auth/domain/entities/auth_provider.dart';
import 'package:lovia/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lovia/features/shell/presentation/controllers/shell_controller.dart';
import 'package:lovia/features/wallet/domain/entities/wallet.dart';
import 'package:lovia/features/wallet/presentation/controllers/wallet_controller.dart';

class DailyTaskPage extends StatelessWidget {
  const DailyTaskPage({super.key});

  static const List<int> _dayRewards = [5, 5, 15, 5, 5, 5, 25];

  void _goToTab(int index) {
    if (Get.isRegistered<ShellController>()) {
      Get.find<ShellController>().index.value = index;
    }
    Get.back<void>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wallet = Get.find<WalletController>();
    final auth = Get.find<AuthController>();

    return AppScaffold(
      appBar: AppBar(title: const Text('Daily task')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Obx(
            () => Row(
              children: [
                Text('Balance: ', style: theme.textTheme.titleMedium),
                const Icon(Icons.public_rounded, color: Color(0xFF5FB7FF), size: 18),
                const SizedBox(width: 4),
                Text('${wallet.balance}', style: theme.textTheme.titleMedium),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _RewardCard(rewards: _dayRewards, wallet: wallet),
          const SizedBox(height: AppSpacing.lg),
          Text('Earn Reward', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          _Task(
            icon: Icons.ondemand_video_rounded,
            title: 'Watch Ad (0/5)',
            reward: '+5',
            actionLabel: 'Watch',
            onAction: () async {
              final ok = await wallet.buyGems(5, 'Watch Ad reward');
              if (ok) Get.snackbar('Reward', '+5 gems added.');
            },
          ),
          _Task(
            icon: Icons.forum_rounded,
            title: 'Talk to 3 characters (1/3)',
            reward: '+5',
            actionLabel: 'Go',
            onAction: () => _goToTab(0),
          ),
          _Task(
            icon: Icons.chat_rounded,
            title: 'Send 20 messages (0/20)',
            reward: '+10',
            actionLabel: 'Go',
            onAction: () => _goToTab(3),
          ),
          _Task(
            icon: Icons.link_rounded,
            title: 'Link Google account',
            reward: '+10',
            actionLabel: 'Link',
            onAction: () => auth.signInWith(AuthProvider.google),
          ),
        ],
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.rewards, required this.wallet});
  final List<int> rewards;
  final WalletController wallet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE08A), Color(0xFFFFC766)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DAILY REWARD',
            style: TextStyle(
              color: Color(0xFF7A4B00),
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Obx(() {
            final claimedToday = !_canCheck();
            return Row(
              children: [
                for (var i = 0; i < rewards.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _DayCell(
                        day: i + 1,
                        reward: rewards[i],
                        done: i == 0 && claimedToday,
                      ),
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(height: AppSpacing.sm),
          Obx(() {
            final canClaim = _canCheck();
            return SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: canClaim ? wallet.claimDaily : null,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE6A800),
                  disabledBackgroundColor: const Color(0x66E6A800),
                ),
                child: Text(canClaim ? 'Claim' : 'Claimed'),
              ),
            );
          }),
        ],
      ),
    );
  }

  bool _canCheck() {
    return switch (wallet.state.value) {
      ViewLoaded<Wallet>(:final data) => data.canCheckInToday,
      _ => true,
    };
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.reward, required this.done});
  final int day;
  final int reward;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      child: Column(
        children: [
          Text('+$reward',
              style: const TextStyle(
                  color: Color(0xFF7A4B00), fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Icon(
            done ? Icons.check_circle : Icons.public_rounded,
            color: done ? Colors.green : const Color(0xFF5FB7FF),
            size: 18,
          ),
          const SizedBox(height: 2),
          Text('Day $day',
              style: const TextStyle(color: Color(0xFF7A4B00), fontSize: 11)),
        ],
      ),
    );
  }
}

class _Task extends StatelessWidget {
  const _Task({
    required this.icon,
    required this.title,
    required this.reward,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String reward;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.violet,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(title),
        subtitle: Text('$reward gems'),
        trailing: FilledButton(onPressed: onAction, child: Text(actionLabel)),
      ),
    );
  }
}
