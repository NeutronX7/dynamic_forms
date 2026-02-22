import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/local/hive_providers.dart';
import '../../data/local/models/records.dart';
import '../widgets/widgets.dart';

class ParentListScreen extends ConsumerWidget {
  const ParentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final box = ref.watch(parentsBoxProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsables'),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<ParentRecord> box, _) {
          final items = box.values.toList().reversed.toList();

          if (items.isEmpty) {
            return const Center(
              child: Text('Aún no hay responsables guardados'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final p = items[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text('${p.firstName} ${p.lastName}'.trim()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if ((p.email).trim().isNotEmpty) Text(p.email),
                      const SizedBox(height: 4),
                      Text('Hijos: ${p.children.length}'),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {

                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: CustomFab(),
    );
  }
}