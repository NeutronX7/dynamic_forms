import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/models/parent_record.dart';
import '../../data/repositories/parents_repository.dart';
import '../../data/local/hive_providers.dart';

final parentListControllerProvider = Provider<ParentListController>((ref) {
  return ParentListController(ref.watch(parentsRepositoryProvider));
});

class ParentListController {
  final ParentsRepository repo;
  ParentListController(this.repo);

  Future<ParentRecord?> deleteWithBackup(String id) async {
    final record = repo.getById(id);
    if (record == null) return null;
    await repo.deleteById(id);
    return record;
  }

  Future<void> undoDelete(ParentRecord record) async {
    await repo.upsert(record);
  }
}