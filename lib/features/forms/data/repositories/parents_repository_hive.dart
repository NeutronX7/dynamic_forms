import 'package:hive/hive.dart';

import '../local/models/parent_record.dart';

class ParentsRepository {
  final Box<ParentRecord> box;

  ParentsRepository(this.box);

  List<ParentRecord> getAll() => box.values.toList();

  ParentRecord? getById(String id) => box.get(id);

  Future<void> upsert(ParentRecord record) async {
    await box.put(record.id, record);
  }

  Future<void> delete(String id) async {
    await box.delete(id);
  }
}