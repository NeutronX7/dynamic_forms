import '../../data/local/models/records.dart';

abstract class ParentsRepository {
  ParentRecord? getById(String id);
  Future<void> upsert(ParentRecord record);
  Future<void> deleteById(String id);

  bool documentIdExists(String documentId, {String? excludeParentId});
  bool phoneExists(String phone, {String? excludeParentId});
}