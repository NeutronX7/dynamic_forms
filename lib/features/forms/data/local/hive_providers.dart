import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../repositories/parents_repository_hive.dart';
import 'models/parent_record.dart';

final parentsBoxProvider = Provider<Box<ParentRecord>>((ref) {
  return Hive.box<ParentRecord>('parents');
});

final parentsRepositoryProvider = Provider<ParentsRepositoryHive>((ref) {
  return ParentsRepositoryHive(ref.watch(parentsBoxProvider));
});