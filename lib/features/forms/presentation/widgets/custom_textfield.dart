import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String value;
  final bool? enabled;
  final String? errorText;
  final String? hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final bool onlyDigits;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.controller,
    this.enabled,
    this.errorText,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onlyDigits = false,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.text != value) {
      controller.value = controller.value.copyWith(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
        composing: TextRange.empty,
      );
    }

    return TextField(
      controller: controller,
      onChanged: onChanged,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      inputFormatters: onlyDigits
          ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
          : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        errorText: errorText,
      ),
    );
  }
}