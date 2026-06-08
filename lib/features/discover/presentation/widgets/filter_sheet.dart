import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/widgets/gradient_button.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({
    required this.genders,
    required this.styles,
    required this.initialGender,
    required this.initialAge,
    required this.initialStyle,
    required this.onApply,
    required this.onReset,
    super.key,
  });

  final List<String> genders;
  final List<String> styles;
  final String? initialGender;
  final String? initialAge;
  final String initialStyle;
  final void Function(String? gender, String? age, String style) onApply;
  final VoidCallback onReset;

  // Age buckets are 18+ only — this is an 18+ app.
  static const List<String> ages = ['18-25', '25-35', '>35'];

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late String? _gender = widget.initialGender;
  late String? _age = widget.initialAge;
  late String _style = widget.initialStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
              Text('Filter', style: theme.textTheme.titleLarge),
              const Spacer(),
              IconButton(
                onPressed: () => Get.back<void>(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _Group(
            title: 'Gender',
            options: widget.genders,
            selected: _gender,
            onSelected: (v) => setState(() => _gender = _toggle(_gender, v)),
          ),
          _Group(
            title: 'Age',
            options: FilterSheet.ages,
            selected: _age,
            onSelected: (v) => setState(() => _age = _toggle(_age, v)),
          ),
          _Group(
            title: 'Style',
            options: widget.styles,
            selected: _style,
            onSelected: (v) => setState(() => _style = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.onReset();
                    Get.back<void>();
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: GradientButton(
                  label: 'Apply',
                  onPressed: () {
                    widget.onApply(_gender, _age, _style);
                    Get.back<void>();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? _toggle(String? current, String value) =>
      current == value ? null : value;
}

class _Group extends StatelessWidget {
  const _Group({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final o in options)
              ChoiceChip(
                label: Text(o),
                selected: selected == o,
                onSelected: (_) => onSelected(o),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
