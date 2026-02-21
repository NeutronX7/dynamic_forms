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

              // Where the form for parent is
              ParentFieldsSection(
                form: form,
                controller: controller,
              ),

              const SizedBox(height: 16),

              // This is the children section
              const ChildrenSection(),

              const SizedBox(height: 16),

              CustomFormButtom(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}