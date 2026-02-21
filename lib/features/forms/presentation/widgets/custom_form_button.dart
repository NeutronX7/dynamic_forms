import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/parent_form_controller.dart';

class CustomFormButtom extends ConsumerWidget {
  final ParentFormController controller;

  const CustomFormButtom({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton(
      onPressed: () {
        final ok = controller.validate();

        if (!ok) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Todos los campos son obligatorios'),
            ),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Formulario válido'),
          ),
        );
      },
      child: const Text('Guardar'),
    );
  }

}