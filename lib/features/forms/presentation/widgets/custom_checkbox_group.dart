import 'package:flutter/material.dart';

class CustomCheckboxGroup extends StatelessWidget {
  final String label;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final String? errorText;

  const CustomCheckboxGroup({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onToggle,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        ...options.map(
              (opt) => CheckboxListTile(
            title: Text(opt),
            value: selected.contains(opt),
            onChanged: (_) => onToggle(opt),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }
}