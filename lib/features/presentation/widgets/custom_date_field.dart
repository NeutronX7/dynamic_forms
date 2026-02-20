import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final String? errorText;
  final VoidCallback onTap;

  const CustomDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final text = value == null ? '' : DateFormat('dd/MM/yyyy').format(value!);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: IgnorePointer(
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            hintText: 'Selecciona una fecha',
            errorText: errorText,
            suffixIcon: const Icon(Icons.calendar_month),
          ),
          controller: TextEditingController(text: text),
          readOnly: true,
        ),
      ),
    );
  }
}