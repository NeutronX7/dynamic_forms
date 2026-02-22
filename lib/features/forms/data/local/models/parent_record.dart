import 'package:hive/hive.dart';
import 'child_record.dart';

part 'parent_record.g.dart';

@HiveType(typeId: 0)
class ParentRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String phone;

  @HiveField(5)
  final DateTime? birthDate;

  @HiveField(6)
  final String documentId;

  @HiveField(7)
  final String? relationship;

  @HiveField(8)
  final String? gender;

  @HiveField(9)
  final List<String> contactChannels;

  @HiveField(10)
  final bool isMarried;

  @HiveField(11)
  final String? occupation;

  @HiveField(12)
  final String observations;

  @HiveField(13)
  final List<ChildRecord> children;

  @HiveField(14)
  final DateTime createdAt;

  @HiveField(15)
  final DateTime updatedAt;

  ParentRecord({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.documentId,
    required this.relationship,
    required this.gender,
    required this.contactChannels,
    required this.isMarried,
    required this.occupation,
    required this.observations,
    required this.children,
    required this.createdAt,
    required this.updatedAt,
  });
}