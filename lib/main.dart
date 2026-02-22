import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'core/routes/app_routes.dart';
import 'features/forms/data/local/models/records.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ParentRecordAdapter());
  Hive.registerAdapter(ChildRecordAdapter());

  await Hive.openBox<ParentRecord>('parents');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.parentList,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}