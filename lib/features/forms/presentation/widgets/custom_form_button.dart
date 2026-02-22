import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/parent_form_providers.dart';

class CustomFormButton extends ConsumerWidget {
  const CustomFormButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(parentFormControllerProvider);
    final controller = ref.read(parentFormControllerProvider.notifier);

    final isEditing = form.id.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        icon: Icon(isEditing ? Icons.save_outlined : Icons.check_circle_outline),
        label: Text(isEditing ? 'Actualizar' : 'Guardar'),
        onPressed: () async {
          final ok = await controller.save();
          if (!ok) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Revisa los campos del formulario')),
            );
            return;
          }

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isEditing ? 'Actualizado' : 'Guardado')),
          );

          Navigator.pop(context);
        },
      ),
    );
  }
}