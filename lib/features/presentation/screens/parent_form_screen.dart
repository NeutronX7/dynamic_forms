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
              Text(
                'Género * (Radio)',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  RadioListTile<String>(
                    title: Text('Masculino'),
                    value: 'Masculino',
                    groupValue: form.gender,
                    onChanged: (v) => controller.setGender(v!),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<String>(
                    title: Text('Femenino'),
                    value: 'Femenino',
                    groupValue: form.gender,
                    onChanged: (v) => controller.setGender(v!),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<String>(
                    title: Text('Otro'),
                    value: 'Otro',
                    groupValue: form.gender,
                    onChanged: (v) => controller.setGender(v!),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<String>(
                    title: Text('Prefiero no decir'),
                    value: 'Prefiero no decir',
                    groupValue: form.gender,
                    onChanged: (v) => controller.setGender(v!),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
              if (form.errors['gender'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    form.errors['gender']!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                'Canales de contacto preferidos * (Checkboxes)',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),

              CheckboxListTile(
                title: const Text('WhatsApp'),
                value: form.contactChannels.contains('WhatsApp'),
                onChanged: (_) => controller.toggleContactChannel('WhatsApp'),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('Email'),
                value: form.contactChannels.contains('Email'),
                onChanged: (_) => controller.toggleContactChannel('Email'),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('Llamada'),
                value: form.contactChannels.contains('Llamada'),
                onChanged: (_) => controller.toggleContactChannel('Llamada'),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),

              if (form.errors['contactChannels'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    form.errors['contactChannels']!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('¿Está casado? (Switch)'),
                value: form.isMarried,
                onChanged: controller.setIsMarried,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 12),

              Text(
                'Ocupación * (Autocomplete)',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),

              Autocomplete<String>(
                initialValue: TextEditingValue(text: form.occupation),
                optionsBuilder: (TextEditingValue textEditingValue) {
                  final query = textEditingValue.text.trim().toLowerCase();
                  if (query.isEmpty) return const Iterable<String>.empty();

                  const options = <String>[
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
                  ];

                  return options.where((o) => o.toLowerCase().contains(query));
                },
                onSelected: (value) {
                  controller.setOccupation(value);
                },
                fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: textController,
                    focusNode: focusNode,
                    onChanged: controller.setOccupation, // importante: guardar texto mientras escribe
                    decoration: InputDecoration(
                      hintText: 'Escribe para buscar...',
                      border: const OutlineInputBorder(),
                      errorText: form.errors['occupation'],
                    ),
                  );
                },
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