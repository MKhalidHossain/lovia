import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lovia/core/constants/storage_keys.dart';
import 'package:lovia/core/theme/app_colors.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/app_scaffold.dart';
import 'package:lovia/core/widgets/gradient_button.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  static const List<(String, String)> _languages = [
    ('🇺🇸', 'United States (English)'),
    ('🇯🇵', 'Japan (Japanese)'),
    ('🇰🇷', 'South Korea (Korean)'),
    ('🇦🇺', 'Australia (English)'),
    ('🇨🇦', 'Canada (English)'),
    ('🇨🇦', 'Canada (French)'),
    ('🇬🇧', 'United Kingdom (English)'),
    ('🇨🇭', 'Switzerland (German)'),
    ('🇨🇭', 'Switzerland (French)'),
    ('🇸🇪', 'Sweden (Swedish)'),
    ('🇩🇪', 'Germany (German)'),
    ('🇫🇷', 'France (French)'),
    ('🇧🇪', 'Belgium (Dutch)'),
  ];

  final GetStorage _box = GetStorage();
  late String _selected =
      _box.read<String>(StorageKeys.locale) ?? _languages.first.$2;

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
                final (flag, label) = _languages[i];
                final selected = _selected == label;
                return GestureDetector(
                  onTap: () => setState(() => _selected = label),
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
                          color: selected ? AppColors.rose : theme.disabledColor,
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
                _box.write(StorageKeys.locale, _selected);
                Get
                  ..back<void>()
                  ..snackbar('Language', 'Saved: $_selected');
              },
            ),
          ),
        ],
      ),
    );
  }
}
