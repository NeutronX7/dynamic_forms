import 'package:dynamic_forms/core/routes/routes.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const parentList = '/';
  static const parentCreate = '/parent/create';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case parentList:
        return MaterialPageRoute(
          builder: (_) => const ParentListScreen(),
          settings: settings,
        );

      case parentCreate:
        return MaterialPageRoute(
          builder: (_) => const ParentFormScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const _NotFoundScreen(),
          settings: settings,
        );
    }
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Ruta no encontrada')),
    );
  }
}