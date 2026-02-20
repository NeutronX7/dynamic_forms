import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParentFormScreen extends ConsumerWidget {
  const ParentFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Nuevo responsable')),
      body: const Center(child: Text('Formulario del responsable aquí')),
    );
  }
}