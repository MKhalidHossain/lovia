import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/features/character/domain/entities/character.dart';

class CharacterAvatar extends StatelessWidget {
  const CharacterAvatar({
    required this.character,
    this.size = 56,
    this.radius = 16,
    super.key,
  });

  final Character character;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final gradient = AppColors.accentGradient(character.accent);
    final initial = character.name.isEmpty ? '?' : character.name[0];
    final fallback = DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
      child: Center(
        child: Text(
          initial.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: size * 0.4,
          ),
        ),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: character.avatarUrl == null
            ? fallback
            : CachedNetworkImage(
                imageUrl: character.avatarUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => fallback,
                errorWidget: (_, __, ___) => fallback,
              ),
      ),
    );
  }
}
