import 'package:dynamic_forms/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/parent_form_controller.dart';
import '../../controllers/parent_form_providers.dart';
import '../../models/parent_form_state.dart';
import '../widgets.dart';

class ParentFieldsSection extends ConsumerWidget {
  final ParentFormState form;
  final ParentFormController controller;

  const ParentFieldsSection({
    super.key,
    required this.form,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(parentFormControllerProvider);
    final controller = ref.read(parentFormControllerProvider.notifier);

    final firstNameC = ref.watch(textControllerProvider('parent:firstName'));
    final lastNameC = ref.watch(textControllerProvider('parent:lastName'));
    final emailC = ref.watch(textControllerProvider('parent:email'));
    final phoneC = ref.watch(textControllerProvider('parent:phone'));
    final docC = ref.watch(textControllerProvider('parent:documentId'));
    final observationsC = ref.watch(textControllerProvider('parent:observations'));

    return Column(
      children: [
        CustomTextField(
          label: 'Nombre *',
          value: form.firstName,
          controller: firstNameC,
          errorText: form.errors['firstName'],
          onChanged: controller.setFirstName,
        ),
        const SizedBox(height: 12),

        CustomTextField(
          label: 'Apellido *',
          value: form.lastName,
          controller: lastNameC,
          errorText: form.errors['lastName'],
          onChanged: controller.setLastName,
        ),
        const SizedBox(height: 12),

        CustomTextField(
          label: 'Email *',
          value: form.email,
          controller: emailC,
          keyboardType: TextInputType.emailAddress,
          errorText: form.errors['email'],
          onChanged: controller.setEmail,
        ),
        const SizedBox(height: 12),

        CustomTextField(
          label: 'Teléfono *',
          value: form.phone,
          controller: phoneC,
          keyboardType: TextInputType.phone,
          onlyDigits: true,
          errorText: form.errors['phone'],
          onChanged: controller.setPhone,
        ),
        const SizedBox(height: 12),
        CustomDateField(
          label: 'Fecha de nacimiento *',
          value: form.birthDate,
          errorText: form.errors['birthDate'],
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: form.birthDate ?? DateTime(now.year - 18, now.month, now.day),
              firstDate: DateTime(1900),
              lastDate: now,
            );
            if (picked != null) controller.setBirthDate(picked);
          },
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Documento de identificación *',
          value: form.documentId,
          controller: docC,
          errorText: form.errors['documentId'],
          onChanged: controller.setDocumentId,
        ),

        const SizedBox(height: 18),
        _OptionalFieldsTile(form: form, controller: controller, observationsC: observationsC),
      ],
    );
  }
}

class _OptionalFieldsTile extends StatelessWidget {
  final ParentFormState form;
  final ParentFormController controller;
  final TextEditingController observationsC;

  const _OptionalFieldsTile({
    required this.form,
    required this.controller,
    required this.observationsC,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text('Información adicional del responsable', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('Toca para agregar más información'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          const SizedBox(height: 8),

          CustomSelectField(
            label: 'Relación',
            value: form.relationship,
            errorText: form.errors['relationship'],
            items: const [
              DropdownMenuItem(value: 'Padre', child: Text('Padre')),
              DropdownMenuItem(value: 'Madre', child: Text('Madre')),
              DropdownMenuItem(value: 'Tutor', child: Text('Tutor'))
            ],
            onChanged: (v) {
              if (v != null) controller.setRelationship(v);
            },
          ),
          const SizedBox(height: 12),

          CustomRadioGroup(
            label: 'Género',
            groupValue: form.gender,
            options: const ['Masculino', 'Femenino'],
            onChanged: controller.setGender,
            errorText: form.errors['gender'],
          ),
          const SizedBox(height: 12),

          CustomCheckboxGroup(
            label: 'Canales de contacto preferidos',
            options: contactOptions,
            selected: form.contactChannels,
            onToggle: controller.toggleContactChannel,
            errorText: form.errors['contactChannels'],
          ),
          const SizedBox(height: 12),

          CustomSwitchField(
            label: '¿Está casado?',
            value: form.isMarried,
            onChanged: controller.setIsMarried,
          ),
          const SizedBox(height: 12),

          CustomAutocompleteField(
            label: 'Ocupación',
            value: form.occupation,
            options: occupations,
            onChanged: controller.setOccupation,
            onSelected: controller.setOccupation,
            errorText: form.errors['occupation'],
          ),
          const SizedBox(height: 12),

          CustomTextField(
            label: 'Observaciones',
            value: form.observations,
            controller: observationsC,
            onChanged: controller.setObservations,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}