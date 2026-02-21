import 'package:flutter/material.dart';

class CustomRadioGroup extends StatelessWidget {
  final String label;
  final String groupValue;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final String? errorText;

  const CustomRadioGroup({
    super.key,
    required this.label,
    required this.groupValue,
    required this.options,
    required this.onChanged,
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
              (opt) => RadioListTile<String>(
            title: Text(opt),
            value: opt,
            groupValue: groupValue,
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
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