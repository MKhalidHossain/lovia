import 'package:flutter/material.dart';

/// Lovia design system colors — derived from the product screenshots.
///
/// Palette: near-black `#0D0407` base with a deep magenta/maroon radial glow
/// (`#5C0F2E → #2A0814`) concentrated top-left. Primary gradient runs
/// pink → purple (`#FF4D5E → #C13BFF`) for buttons and accents.
abstract final class AppColors {
  // Gradient stops (also exposed individually for fills/icons).
  static const Color rose = Color(0xFFFF4D5E); // primary gradient start (pink)
  static const Color violet = Color(0xFFC13BFF); // primary gradient end (purple)

  /// Primary CTA / accent gradient — pink → purple (horizontal).
  static const LinearGradient brandGradient = LinearGradient(
    colors: [rose, violet],
  );

  /// Standalone accent pink used for highlighted text (e.g. selected language).
  static const Color accentPink = Color(0xFFFF2D78);

  /// Blue gem coin used in the wallet/coin chip.
  static const Color gem = Color(0xFF35C2F0);

  static const Color amber = Color(0xFFFFC766);
  static const Color gold = Color(0xFFE9B949);

  static const Color success = Color(0xFF4ADE80);
  static const Color error = Color(0xFFFF6B6B);
  static const Color info = Color(0xFF6FB7FF);

  // Dark theme (primary surface set the whole app uses).
  static const Color darkBase = Color(0xFF0D0407); // near-black background
  static const Color darkSurface = Color(0xFF1A1A1C); // cards
  static const Color darkSurfaceHigh = Color(0xFF1F1F22); // sheets / inputs
  static const Color darkHairline = Color(0x1FFFFFFF);
  static const Color darkTextHigh = Color(0xFFF7F2F5);
  static const Color darkTextMedium = Color(0xFFB9AEB6);
  static const Color darkTextDisabled = Color(0xFF6E646B);

  // Radial glow stops painted behind the base (top-left).
  static const Color glowMagenta = Color(0xFF5C0F2E);
  static const Color glowMaroon = Color(0xFF2A0814);

  // Light theme (kept for completeness; the product runs dark).
  static const Color lightBase = Color(0xFFFAF7FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceHigh = Color(0xFFF1ECFA);
  static const Color lightHairline = Color(0x14000000);
  static const Color lightTextHigh = Color(0xFF1B1430);
  static const Color lightTextMedium = Color(0xFF5C5470);
  static const Color lightTextDisabled = Color(0xFFA39DB3);

  /// Translucent white used for glass chips (`white @ 12% opacity`).
  static const Color glassChip = Color(0x1FFFFFFF);
  static const Color glassOverlayDark = Color(0x14FFFFFF);
  static const Color glassOverlayLight = Color(0x0A000000);

  static const List<List<Color>> _accents = [
    [Color(0xFFFF4D5E), Color(0xFFC13BFF)],
    [Color(0xFF5EE7DF), Color(0xFFB490CA)],
    [Color(0xFFFFA07A), Color(0xFFFF4D5E)],
    [Color(0xFF6FB7FF), Color(0xFFC13BFF)],
    [Color(0xFFFFC766), Color(0xFFFF8A5B)],
    [Color(0xFF8A6CFF), Color(0xFF4ADE80)],
    [Color(0xFFFF8FB1), Color(0xFFFFC766)],
    [Color(0xFF7DD3FC), Color(0xFF818CF8)],
  ];

  static LinearGradient accentGradient(int seed) {
    final colors = _accents[seed.abs() % _accents.length];
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
