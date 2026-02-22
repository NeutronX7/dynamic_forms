import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/parent_form_providers.dart';
import '../widgets/widgets.dart';

class ParentFormScreen extends ConsumerWidget {
  final String? parentId;
  const ParentFormScreen({super.key, this.parentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(parentFormControllerProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = parentId;
      if (id == null) return;
      if (controller.isLoadedFor(id)) return;
      controller.loadForEdit(id);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(parentId == null ? 'Nuevo responsable' : 'Editar responsable'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const ParentFieldsSection(),
              const SizedBox(height: 16),
              const ChildrenSection(),
              const SizedBox(height: 16),
              CustomFormButton(),
            ],
          ),
        ),
      ),
    );
  }
}