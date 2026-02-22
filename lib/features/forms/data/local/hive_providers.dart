import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../repositories/parents_repository.dart';
import '../repositories/parents_repository_hive.dart';
import 'models/parent_record.dart';

final parentsBoxProvider = Provider<Box<ParentRecord>>((ref) {
  return Hive.box<ParentRecord>('parents');
});

final parentsRepositoryProvider = Provider<ParentsRepository>((ref) {
  return ParentsRepositoryHive(ref.watch(parentsBoxProvider));
});

final parentsBoxListenableProvider = Provider<ValueListenable<Box<ParentRecord>>>((ref) {
  final box = ref.watch(parentsBoxProvider);
  return box.listenable();
});