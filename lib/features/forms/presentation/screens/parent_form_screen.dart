import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/parent_form_providers.dart';
import '../widgets/widgets.dart';

class ParentFormScreen extends ConsumerStatefulWidget {
  final String? parentId;
  const ParentFormScreen({super.key, this.parentId});

  @override
  ConsumerState<ParentFormScreen> createState() => _ParentFormScreenState();
}

class _ParentFormScreenState extends ConsumerState<ParentFormScreen> {

  @override
  void initState() {
    super.initState();

    final id = widget.parentId;
    if (id != null) {
      Future.microtask(() {
        ref.read(parentFormControllerProvider.notifier).loadForEdit(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final parentId = widget.parentId;

    return Scaffold(
      appBar: AppBar(
        title: Text(parentId == null ? 'Nuevo responsable' : 'Editar responsable'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: const [
              ParentFieldsSection(),
              SizedBox(height: 16),
              ChildrenSection(),
              SizedBox(height: 16),
              CustomFormButton(),
            ],
          ),
        ),
      ),
    );
  }
}