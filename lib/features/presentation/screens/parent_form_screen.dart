import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/parent_form_controller.dart';
import '../widgets/widgets.dart';

class ParentFormScreen extends ConsumerWidget {
  const ParentFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final form = ref.watch(parentFormControllerProvider);
    final controller = ref.read(parentFormControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo responsable')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
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
                textInputAction: TextInputAction.done,
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

                  if (picked != null) {
                    controller.setBirthDate(picked);
                  }
                },
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Documento de identificación *',
                errorText: form.errors['documentId'],
                onChanged: controller.setDocumentId,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 12),
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Relación * (Select)',
                  errorText: form.errors['relationship'],
                  border: const OutlineInputBorder(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: form.relationship,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'Padre', child: Text('Padre')),
                      DropdownMenuItem(value: 'Madre', child: Text('Madre')),
                      DropdownMenuItem(value: 'Tutor', child: Text('Tutor')),
                    ],
                    onChanged: (v) {
                      if (v != null) controller.setRelationship(v);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CustomFormButtom(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}