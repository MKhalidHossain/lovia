import 'package:flutter/material.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/theme/app_typography.dart';

abstract final class AppTheme {
  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        base: AppColors.darkBase,
        surface: AppColors.darkSurface,
        surfaceHigh: AppColors.darkSurfaceHigh,
        hairline: AppColors.darkHairline,
        textHigh: AppColors.darkTextHigh,
        textMedium: AppColors.darkTextMedium,
        textDisabled: AppColors.darkTextDisabled,
      );

  static ThemeData get light => _build(
        brightness: Brightness.light,
        base: AppColors.lightBase,
        surface: AppColors.lightSurface,
        surfaceHigh: AppColors.lightSurfaceHigh,
        hairline: AppColors.lightHairline,
        textHigh: AppColors.lightTextHigh,
        textMedium: AppColors.lightTextMedium,
        textDisabled: AppColors.lightTextDisabled,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color base,
    required Color surface,
    required Color surfaceHigh,
    required Color hairline,
    required Color textHigh,
    required Color textMedium,
    required Color textDisabled,
  }) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.rose,
      onPrimary: Colors.white,
      secondary: AppColors.violet,
      onSecondary: Colors.white,
      tertiary: AppColors.amber,
      onTertiary: AppColors.darkBase,
      error: AppColors.error,
      onError: Colors.white,
      surface: surface,
      onSurface: textHigh,
      surfaceContainerHighest: surfaceHigh,
      outline: hairline,
    );

    final textTheme = AppTypography.textTheme(textHigh, textMedium);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: base,
      colorScheme: scheme,
      textTheme: textTheme,
      dividerColor: hairline,
      disabledColor: textDisabled,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: textHigh,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          side: BorderSide(color: hairline),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceHigh,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: textDisabled),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: BorderSide(color: hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: BorderSide(color: hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.violet, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.rose,
        unselectedItemColor: textMedium,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: surfaceHigh,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
      ),
    );
  }
}
