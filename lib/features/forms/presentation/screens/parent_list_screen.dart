import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/widgets.dart';

class ParentListScreen extends ConsumerWidget {

  const ParentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsables'),
      ),
      body: const Center(
        child: Text('Lista de responsables'),
      ),
      floatingActionButton: CustomFab(),
    );
  }
}