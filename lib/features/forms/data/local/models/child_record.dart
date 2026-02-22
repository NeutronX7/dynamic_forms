import 'package:hive/hive.dart';

part 'child_record.g.dart';

@HiveType(typeId: 1)
class ChildRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final int? age;

  @HiveField(4)
  final DateTime? birthDate;

  @HiveField(5)
  final String hairColor;

  @HiveField(6)
  final String code;

  ChildRecord({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.birthDate,
    required this.hairColor,
    required this.code,
  });
}