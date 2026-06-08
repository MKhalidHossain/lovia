import 'package:flutter/material.dart';

abstract final class AppColors {

  static const Color rose = Color(0xFFFF6FA5);
  static const Color violet = Color(0xFF9B6CFF);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [rose, violet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color amber = Color(0xFFFFC766);

  static const Color success = Color(0xFF4ADE80);
  static const Color error = Color(0xFFFF6B6B);
  static const Color info = Color(0xFF6FB7FF);

  static const Color darkBase = Color(0xFF15101C);
  static const Color darkSurface = Color(0xFF1F1830);
  static const Color darkSurfaceHigh = Color(0xFF2A2140);
  static const Color darkHairline = Color(0x1FFFFFFF);
  static const Color darkTextHigh = Color(0xFFF5F1FF);
  static const Color darkTextMedium = Color(0xFFB7AECB);
  static const Color darkTextDisabled = Color(0xFF6E667E);

  static const Color lightBase = Color(0xFFFAF7FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceHigh = Color(0xFFF1ECFA);
  static const Color lightHairline = Color(0x14000000);
  static const Color lightTextHigh = Color(0xFF1B1430);
  static const Color lightTextMedium = Color(0xFF5C5470);
  static const Color lightTextDisabled = Color(0xFFA39DB3);

  static const Color glassOverlayDark = Color(0x14FFFFFF);
  static const Color glassOverlayLight = Color(0x0A000000);

  static const List<List<Color>> _accents = [
    [Color(0xFFFF6FA5), Color(0xFF9B6CFF)],
    [Color(0xFF5EE7DF), Color(0xFFB490CA)],
    [Color(0xFFFFA07A), Color(0xFFFF6FA5)],
    [Color(0xFF6FB7FF), Color(0xFF9B6CFF)],
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
