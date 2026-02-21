import 'package:flutter/material.dart';

import '../../controllers/parent_form_controller.dart';
import '../widgets.dart';

class ParentFieldsSection extends StatelessWidget {
  final ParentFormState form;
  final ParentFormController controller;

  const ParentFieldsSection({
    super.key,
    required this.form,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: 'Nombre *',
          errorText: form.errors['firstName'],
          onChanged: controller.setFirstName,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Apellido *',
          errorText: form.errors['lastName'],
          onChanged: controller.setLastName,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Email *',
          keyboardType: TextInputType.emailAddress,
          errorText: form.errors['email'],
          onChanged: controller.setEmail,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Teléfono *',
          hintText: 'Mínimo 8 dígitos',
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
          errorText: form.errors['documentId'],
          onChanged: controller.setDocumentId,
        ),

        const SizedBox(height: 18),

        CustomSelectField(
          label: 'Relación *',
          value: form.relationship,
          errorText: form.errors['relationship'],
          items: const [
            DropdownMenuItem(value: 'Padre', child: Text('Padre')),
            DropdownMenuItem(value: 'Madre', child: Text('Madre')),
            DropdownMenuItem(value: 'Tutor', child: Text('Tutor')),
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
          options: const ['WhatsApp', 'Email', 'Llamada'],
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
          options: const [
            'Doctor/a',
            'Maestro/a',
            'Ingeniero/a',
            'Abogado/a',
            'Contador/a',
            'Enfermero/a',
            'Policía',
            'Comerciante',
            'Estudiante',
            'Otro',
          ],
          onChanged: controller.setOccupation,
          onSelected: controller.setOccupation,
          errorText: form.errors['occupation'],
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Observaciones',
          onChanged: controller.setObservations,
          maxLines: 4,
        ),
      ],
    );
  }
}