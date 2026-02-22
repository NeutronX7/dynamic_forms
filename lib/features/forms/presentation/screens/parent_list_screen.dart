import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/routes/app_routes.dart';
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
                      if (p.email.trim().isNotEmpty) Text(p.email),
                      const SizedBox(height: 4),
                      Text('Hijos: ${p.children.length}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        tooltip: 'Eliminar',
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Eliminar responsable'),
                              content: Text(
                                '¿Eliminar a ${p.firstName} ${p.lastName} y todos sus hijos?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            final deleted = ParentRecord(
                              id: p.id,
                              firstName: p.firstName,
                              lastName: p.lastName,
                              email: p.email,
                              phone: p.phone,
                              birthDate: p.birthDate,
                              documentId: p.documentId,
                              relationship: p.relationship,
                              gender: p.gender,
                              contactChannels: p.contactChannels,
                              isMarried: p.isMarried,
                              occupation: p.occupation,
                              observations: p.observations,
                              children: p.children.map((c) {
                                return ChildRecord(
                                  id: c.id,
                                  firstName: c.firstName,
                                  lastName: c.lastName,
                                  age: c.age,
                                  birthDate: c.birthDate,
                                  hairColor: c.hairColor,
                                  code: c.code,
                                );
                              }).toList(),
                              createdAt: p.createdAt,
                              updatedAt: p.updatedAt,
                            );

                            await box.delete(p.id);

                            if (!context.mounted) return;

                            final messenger = ScaffoldMessenger.of(context);
                            messenger.hideCurrentSnackBar();

                            messenger.showSnackBar(
                              SnackBar(
                                content: Text('Responsable eliminado: ${p.firstName} ${p.lastName}'),
                                duration: const Duration(seconds: 5),
                                action: SnackBarAction(
                                  label: 'DESHACER',
                                  onPressed: () async {
                                    await box.put(deleted.id, deleted);
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.parentForm,
                      arguments: p.id,
                    );
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