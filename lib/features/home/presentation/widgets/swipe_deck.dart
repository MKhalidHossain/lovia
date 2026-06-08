import 'package:flutter/material.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/character/presentation/widgets/character_avatar.dart';

class SwipeDeck extends StatefulWidget {
  const SwipeDeck({
    required this.current,
    required this.peek,
    required this.onPass,
    required this.onLike,
    required this.onChat,
    required this.onOpen,
    super.key,
  });

  final Character current;
  final Character? peek;
  final VoidCallback onPass;
  final VoidCallback onLike;
  final VoidCallback onChat;
  final VoidCallback onOpen;

  @override
  State<SwipeDeck> createState() => _SwipeDeckState();
}

class _SwipeDeckState extends State<SwipeDeck>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fly = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );
  Offset _drag = Offset.zero;
  double _flyDir = 0;

  @override
  void dispose() {
    _fly.dispose();
    super.dispose();
  }

  void _flyOff(double dir, VoidCallback after) {
    _flyDir = dir;
    _fly.forward(from: 0).whenComplete(() {
      after();
      setState(() {
        _drag = Offset.zero;
        _fly.value = 0;
      });
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() => _drag += d.delta);
  }

  void _onPanEnd(DragEndDetails d, double width) {
    if (_drag.dx.abs() > width * 0.28) {
      final dir = _drag.dx.sign;
      _flyOff(dir, dir > 0 ? widget.onLike : widget.onPass);
    } else {
      setState(() => _drag = Offset.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Column(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _fly,
                builder: (context, _) {
                  final flyOffset = _fly.value * width * 1.6 * _flyDir;
                  final total = _drag + Offset(flyOffset, 0);
                  final angle = (total.dx / width) * 0.5;
                  final likeOpacity = (total.dx / (width * 0.3)).clamp(0.0, 1.0);
                  final nopeOpacity =
                      (-total.dx / (width * 0.3)).clamp(0.0, 1.0);
                  return Stack(
                    children: [
                      if (widget.peek != null)
                        Center(
                          child: FractionallySizedBox(
                            widthFactor: 0.92,
                            heightFactor: 0.96,
                            child: _Card(character: widget.peek!, onTap: null),
                          ),
                        ),
                      Transform.translate(
                        offset: total,
                        child: Transform.rotate(
                          angle: angle,
                          child: GestureDetector(
                            onPanUpdate: _onPanUpdate,
                            onPanEnd: (d) => _onPanEnd(d, width),
                            onTap: widget.onOpen,
                            child: _Card(
                              character: widget.current,
                              onTap: null,
                              likeOpacity: likeOpacity,
                              nopeOpacity: nopeOpacity,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(
                  icon: Icons.close_rounded,
                  color: AppColors.error,
                  background: Colors.white,
                  onTap: () => _flyOff(-1, widget.onPass),
                ),
                const SizedBox(width: AppSpacing.xl),
                _ActionButton(
                  icon: Icons.chat_bubble_rounded,
                  color: Colors.white,
                  gradient: AppColors.brandGradient,
                  size: 68,
                  onTap: widget.onChat,
                ),
                const SizedBox(width: AppSpacing.xl),
                _ActionButton(
                  icon: Icons.favorite_rounded,
                  color: AppColors.rose,
                  background: Colors.white,
                  onTap: () => _flyOff(1, widget.onLike),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.character,
    required this.onTap,
    this.likeOpacity = 0,
    this.nopeOpacity = 0,
  });

  final Character character;
  final VoidCallback? onTap;
  final double likeOpacity;
  final double nopeOpacity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CharacterAvatar(character: character, size: double.infinity, radius: 0),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC15101C)],
                  stops: [0.5, 1],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    children: [
                      for (final t in character.traits.take(3))
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(AppRadii.pill),
                          ),
                          child: Text(
                            t,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    character.bio,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                  ),
                ],
              ),
            ),
            Positioned(
              top: AppSpacing.lg,
              left: AppSpacing.lg,
              child: _Stamp(
                label: 'LIKE',
                color: AppColors.success,
                opacity: likeOpacity,
                angle: -0.3,
              ),
            ),
            Positioned(
              top: AppSpacing.lg,
              right: AppSpacing.lg,
              child: _Stamp(
                label: 'NOPE',
                color: AppColors.error,
                opacity: nopeOpacity,
                angle: 0.3,
              ),
            ),
            // Keep the theme reference meaningful for hairline border.
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.xl),
                    border: Border.all(color: theme.dividerColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stamp extends StatelessWidget {
  const _Stamp({
    required this.label,
    required this.color,
    required this.opacity,
    required this.angle,
  });

  final String label;
  final Color color;
  final double opacity;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 3),
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.background,
    this.gradient,
    this.size = 56,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final Color? background;
  final Gradient? gradient;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: background,
          gradient: gradient,
          boxShadow: const [
            BoxShadow(color: Color(0x33000000), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Icon(icon, color: color, size: size * 0.46),
      ),
    );
  }
}
