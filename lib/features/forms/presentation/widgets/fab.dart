import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routes/app_routes.dart';
import '../controllers/parent_form_providers.dart';

class CustomFab extends ConsumerWidget {
  const CustomFab({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        ref.read(parentFormControllerProvider.notifier).reset();
        Navigator.pushNamed(context, AppRoutes.parentForm);
      },
      child: const Icon(Icons.add),
    );
  }
}