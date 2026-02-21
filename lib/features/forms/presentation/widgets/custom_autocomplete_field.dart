import 'package:flutter/material.dart';

class CustomAutocompleteField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSelected;
  final String? errorText;
  final String hintText;

  const CustomAutocompleteField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.onSelected,
    this.errorText,
    this.hintText = 'Escribe para buscar...',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Autocomplete<String>(
          initialValue: TextEditingValue(text: value),
          optionsBuilder: (TextEditingValue textEditingValue) {
            final query = textEditingValue.text.trim().toLowerCase();
            if (query.isEmpty) return const Iterable<String>.empty();
            return options.where((o) => o.toLowerCase().contains(query));
          },
          onSelected: onSelected,
          fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: textController,
              focusNode: focusNode,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                border: const OutlineInputBorder(),
                errorText: errorText,
              ),
            );
          },
        ),
      ],
    );
  }
}