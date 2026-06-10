import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lovia/core/constants/storage_keys.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/app_scaffold.dart';
import 'package:lovia/core/widgets/gradient_button.dart';
import 'package:lovia/features/auth/presentation/controllers/auth_controller.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  // (flag, label, locale code)
  static const List<(String, String, String)> _languages = [
    ('🇺🇸', 'United States (English)', 'en-US'),
    ('🇯🇵', 'Japan (Japanese)', 'ja-JP'),
    ('🇰🇷', 'South Korea (Korean)', 'ko-KR'),
    ('🇦🇺', 'Australia (English)', 'en-AU'),
    ('🇨🇦', 'Canada (English)', 'en-CA'),
    ('🇨🇦', 'Canada (French)', 'fr-CA'),
    ('🇬🇧', 'United Kingdom (English)', 'en-GB'),
    ('🇨🇭', 'Switzerland (German)', 'de-CH'),
    ('🇨🇭', 'Switzerland (French)', 'fr-CH'),
    ('🇸🇪', 'Sweden (Swedish)', 'sv-SE'),
    ('🇩🇪', 'Germany (German)', 'de-DE'),
    ('🇫🇷', 'France (French)', 'fr-FR'),
    ('🇧🇪', 'Belgium (Dutch)', 'nl-BE'),
  ];

  final GetStorage _box = GetStorage();
  late String _selectedCode =
      _box.read<String>(StorageKeys.locale) ?? _languages.first.$3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      appBar: AppBar(title: const Text('Language')),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _languages.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, i) {
                final (flag, label, code) = _languages[i];
                final selected = _selectedCode == code;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCode = code),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppRadii.md),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        Text(flag, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
                        Icon(
                          selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: selected
                              ? AppColors.accentPink
                              : theme.disabledColor,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: GradientButton(
              label: 'Save',
              onPressed: () {
                // Persist locally and best-effort PATCH /users/me.
                _box.write(StorageKeys.locale, _selectedCode);
                final label = _languages
                    .firstWhere((l) => l.$3 == _selectedCode)
                    .$2;
                unawaited(Get.find<AuthController>().updateLanguage(_selectedCode));
                Get
                  ..back<void>()
                  ..snackbar('Language', 'Saved: $label');
              },
            ),
          ),
        ],
      ),
    );
  }
}
