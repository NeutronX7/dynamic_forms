import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routes/app_routes.dart';

class CustomFab extends ConsumerWidget {
  const CustomFab({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed(AppRoutes.parentCreate);
      },
      child: const Icon(Icons.add),
    );
  }
}