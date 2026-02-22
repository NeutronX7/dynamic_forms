import 'package:dynamic_forms/features/forms/data/repositories/parents_repository.dart';
import 'package:hive/hive.dart';

import '../local/models/parent_record.dart';

class ParentsRepositoryHive implements ParentsRepository {
  final Box<ParentRecord> box;

  ParentsRepositoryHive(this.box);

  @override
  ParentRecord? getById(String id) => box.get(id);

  @override
  Future<void> upsert(ParentRecord record) async {
    await box.put(record.id, record);
  }

  @override
  Future<void> deleteById(String id) async {
    await box.delete(id);
  }

  @override
  bool documentIdExists(String documentId, {String? excludeParentId}) {
    final doc = documentId.trim();
    if (doc.isEmpty) return false;

    for (final p in box.values) {
      if (excludeParentId != null && p.id == excludeParentId) continue;
      if (p.documentId.trim() == doc) return true;
    }
    return false;
  }

  @override
  bool phoneExists(String phone, {String? excludeParentId}) {
    final ph = phone.trim();
    if (ph.isEmpty) return false;

    for (final p in box.values) {
      if (excludeParentId != null && p.id == excludeParentId) continue;
      if (p.phone.trim() == ph) return true;
    }
    return false;
  }
}