import 'package:dynamic_forms/features/forms/presentation/models/child_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/const_values.dart';
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
                key: ValueKey(child.id),
                padding: const EdgeInsets.only(bottom: 12),
                child: _ChildFormTile(
                  index: index,
                  childNumber: index + 1,
                  child: child,
                  totalChildren: form.children.length,
                ),
              );
            })
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
  final int totalChildren;

  const _ChildFormTile({
    required this.index,
    required this.childNumber,
    required this.child,
    required this.totalChildren
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(parentFormControllerProvider.notifier);
    final hasCode = child.code.trim().isNotEmpty;
    final canDelete = totalChildren > 1;

    final firstNameC = ref.watch(textControllerProvider('child:${child.id}:firstName'));
    final lastNameC  = ref.watch(textControllerProvider('child:${child.id}:lastName'));
    final ageC       = ref.watch(textControllerProvider('child:${child.id}:age'));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text('Hijo $childNumber • ${child.code.isEmpty ? "—" : child.code}'),
        subtitle: Text(
          hasCode ? 'Código generado' : 'Completa nombre, apellido y fecha para generar el código',
        ),
        trailing: IconButton(
          tooltip: canDelete ? 'Eliminar hijo' : 'No puedes eliminar el último hijo',
          onPressed: canDelete ? () => controller.removeChild(index) : null,
          icon: const Icon(Icons.delete_outline),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          const SizedBox(height: 8),

          _ChildCodeBanner(code: child.code),

          const SizedBox(height: 12),

          CustomTextField(
            label: 'Nombre *',
            value: child.firstName,
            controller: firstNameC,
            errorText: child.errors['firstName'],
            onChanged: (v) => controller.setChildFirstName(index, v),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Apellido *',
            value: child.lastName,
            controller: lastNameC,
            errorText: child.errors['lastName'],
            onChanged: (v) => controller.setChildLastName(index, v),
          ),
          const SizedBox(height: 12),
          CustomDateField(
            label: 'Fecha de nacimiento *',
            value: child.birthDate,
            errorText: child.errors['birthDate'],
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
            label: 'Edad *',
            value: child.age?.toString() ?? '',
            controller: ageC,
            enabled: false,
            keyboardType: TextInputType.number,
            onlyDigits: true,
            onChanged: null,
            errorText: child.errors['age'],
          ),
          const SizedBox(height: 12),
          CustomRadioGroup(
            label: 'Color de pelo *',
            groupValue: child.hairColor.isNotEmpty ? child.hairColor : hairColors.first,
            options: hairColors,
            errorText: child.errors['hairColor'],
            onChanged: (v) => controller.setChildHairColor(index, v),
          ),
        ],
      ),
    );
  }
}

class _ChildCodeBanner extends StatelessWidget {
  final String code;

  const _ChildCodeBanner({required this.code});

  @override
  Widget build(BuildContext context) {
    final hasCode = code.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasCode
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        children: [
          Icon(hasCode ? Icons.qr_code_2 : Icons.info_outline),
          const SizedBox(width: 10),
          Expanded(
            child: hasCode
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Código del hijo',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  code,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            )
                : Text(
              'El código se genera automáticamente al completar nombre, apellido y fecha de nacimiento.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}