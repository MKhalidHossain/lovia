import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/app_scaffold.dart';
import 'package:lovia/core/widgets/gem_badge.dart';
import 'package:lovia/features/wallet/presentation/controllers/wallet_controller.dart';

class _GemPack {
  const _GemPack({
    required this.gems,
    required this.base,
    required this.bonus,
    required this.price,
    this.discount,
  });
  final int gems;
  final int base;
  final int bonus;
  final String price;
  final String? discount;
}

class TopUpPage extends StatelessWidget {
  const TopUpPage({super.key});

  static const List<_GemPack> _packs = [
    _GemPack(gems: 50, base: 50, bonus: 0, price: 'BDT 290.00'),
    _GemPack(gems: 150, base: 100, bonus: 50, price: 'BDT 700.00', discount: '20% Off'),
    _GemPack(gems: 400, base: 200, bonus: 200, price: 'BDT 1,400.00', discount: '40% Off'),
    _GemPack(gems: 1000, base: 450, bonus: 550, price: 'BDT 2,800.00', discount: '52% Off'),
    _GemPack(gems: 3000, base: 1200, bonus: 1800, price: 'BDT 7,000.00', discount: '60% Off'),
    _GemPack(gems: 6000, base: 2400, bonus: 3600, price: 'BDT 14,000.00', discount: '60% Off'),
  ];

  Future<void> _buy(_GemPack pack) async {
    final wallet = Get.find<WalletController>();
    final ok = await wallet.buyGems(pack.gems, '${pack.gems} gems pack');
    Get.snackbar(
      ok ? 'Purchase complete' : 'Purchase failed',
      ok
          ? '+${pack.gems} gems added (demo — no payment taken).'
          : 'Something went wrong.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Top up'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: Center(child: GemBadge()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('Membership', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          _MembershipCard(
            onSubscribe: () => Get.toNamed<void>(AppRoutes.premium),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Gems shop', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.25,
            ),
            itemCount: _packs.length,
            itemBuilder: (context, i) => _GemTile(
              pack: _packs[i],
              onTap: () => _buy(_packs[i]),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Mission', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.rose,
                child: Text('Ad', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
              title: const Text('Watch Ad (0/5)'),
              subtitle: const Text('+5 gems'),
              trailing: FilledButton(
                onPressed: () async {
                  final ok = await Get.find<WalletController>()
                      .buyGems(5, 'Watch Ad reward');
                  if (ok) Get.snackbar('Reward', '+5 gems added.');
                },
                child: const Text('Watch'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MembershipCard extends StatelessWidget {
  const _MembershipCard({required this.onSubscribe});
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE2B8), Color(0xFFFFC1D9)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.workspace_premium_rounded, color: Color(0xFF7A4B00)),
              SizedBox(width: AppSpacing.xs),
              Text(
                'Monthly Premium',
                style: TextStyle(
                  color: Color(0xFF7A4B00),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Ad-free, unlimited chat, outfit selection, and character '
            'creation. Bonus 700 gems.',
            style: TextStyle(color: Color(0xFF5A3A10)),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'BDT 2,800.00',
                style: TextStyle(
                  color: Color(0xFF7A4B00),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              FilledButton(
                onPressed: onSubscribe,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.rose,
                ),
                child: const Text('Subscribe now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GemTile extends StatelessWidget {
  const _GemTile({required this.pack, required this.onTap});
  final _GemPack pack;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadii.lg),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${pack.gems}',
                              style: theme.textTheme.titleLarge),
                          const SizedBox(width: 4),
                          const Icon(Icons.public_rounded,
                              color: Color(0xFF5FB7FF), size: 18),
                        ],
                      ),
                      Text(
                        pack.bonus > 0
                            ? '${pack.base}  +${pack.bonus}'
                            : '${pack.base}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(AppRadii.lg),
                    ),
                  ),
                  child: Center(
                    child: Text(pack.price, style: theme.textTheme.bodyMedium),
                  ),
                ),
              ],
            ),
          ),
          if (pack.discount != null)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: const BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppRadii.lg),
                    bottomRight: Radius.circular(AppRadii.lg),
                  ),
                ),
                child: Text(
                  pack.discount!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
