import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/parent_form_providers.dart';

class ChildrenSection extends ConsumerWidget {
  const ChildrenSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(parentFormControllerProvider);
    final controller = ref.read(parentFormControllerProvider.notifier);

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
                    'Hijos',
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
          ],
        ),
      ),
    );
  }
}

class _ChildrenFormTile extends ConsumerWidget {


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ExpansionTile(
        title: Text('Hijos'),
        subtitle: Text('Campos del hijo'),
        children: [

        ],
      ),
    );
  }

}