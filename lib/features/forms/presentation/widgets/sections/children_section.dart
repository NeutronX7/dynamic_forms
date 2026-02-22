import 'package:dynamic_forms/features/forms/presentation/models/child_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/parent_form_providers.dart';
import '../../widgets/widgets.dart';

class ChildrenSection extends ConsumerWidget {
  const ChildrenSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(parentFormControllerProvider);
    final controller = ref.read(parentFormControllerProvider.notifier);
    final childrenError = form.errors['children'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.family_restroom),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Hijos *',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                Text('${form.children.length}'),
              ],
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: controller.addChild,
                icon: const Icon(Icons.add),
                label: const Text('Agregar hijo'),
              ),
            ),

            if (childrenError != null) ...[
              const SizedBox(height: 12),
              Text(
                childrenError,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            const SizedBox(height: 12),

            ...List.generate(form.children.length, (index) {
              final child = form.children[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ChildFormTile(
                  index: index,
                  childNumber: index + 1,
                  child: child,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ChildFormTile extends ConsumerWidget {
  final int index;
  final int childNumber;
  final ChildFormState child;

  const _ChildFormTile({
    required this.index,
    required this.childNumber,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(parentFormControllerProvider.notifier);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          'Hijo $childNumber',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: const Text('Completa los datos del hijo'),
        trailing: IconButton(
          tooltip: 'Eliminar hijo',
          onPressed: () => controller.removeChild(index),
          icon: const Icon(Icons.delete_outline),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          const SizedBox(height: 8),

          CustomTextField(
            label: 'Nombre *',
            errorText: (child.errors)['firstName'],
            onChanged: (v) => controller.setChildFirstName(index, v),
          ),
          const SizedBox(height: 12),

          CustomTextField(
            label: 'Apellido *',
            errorText: (child.errors)['lastName'],
            onChanged: (v) => controller.setChildLastName(index, v),
          ),
          const SizedBox(height: 12),

          CustomTextField(
            label: 'Edad *',
            keyboardType: TextInputType.number,
            onlyDigits: true,
            errorText: (child.errors)['age'],
            onChanged: (v) => controller.setChildAge(index, int.tryParse(v)),
          ),
          const SizedBox(height: 12),

          CustomDateField(
            label: 'Fecha de nacimiento *',
            value: child.birthDate,
            errorText: (child.errors)['birthDate'],
            onTap: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: child.birthDate ?? DateTime(now.year - 5, now.month, now.day),
                firstDate: DateTime(1900),
                lastDate: now,
              );
              if (picked != null) controller.setChildBirthDate(index, picked);
            },
          ),
          const SizedBox(height: 12),

          CustomTextField(
            label: 'Color de pelo',
            errorText: (child.errors)['hairColor'],
            onChanged: (v) => controller.setChildHairColor(index, v),
          ),
        ],
      ),
    );
  }
}