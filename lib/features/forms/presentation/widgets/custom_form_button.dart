import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/parent_form_controller.dart';

class CustomFormButtom extends ConsumerWidget {
  final ParentFormController controller;

  const CustomFormButtom({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton(
      onPressed: () async {
        final ok = await controller.save();
        if (!ok) return;

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardado correctamente')),
          );
        }
      },
      child: const Text('Guardar'),
    );
  }

}