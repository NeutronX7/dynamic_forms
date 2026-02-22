import '../../presentation/models/child_form_state.dart';
import '../local/models/records.dart';
import '../../presentation/models/parent_form_state.dart';

class ParentRecordMapper {
  ParentRecord fromForm({
    required ParentFormState state,
    required String id,
    required DateTime now,
  }) {
    return ParentRecord(
      id: id,
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      phone: state.phone,
      birthDate: state.birthDate,
      documentId: state.documentId,
      relationship: state.relationship,
      gender: state.gender,
      contactChannels: state.contactChannels.toList(),
      isMarried: state.isMarried,
      occupation: state.occupation,
      observations: state.observations,
      children: state.children.map((c) => ChildRecord(
        id: c.id,
        firstName: c.firstName,
        lastName: c.lastName,
        age: c.age,
        birthDate: c.birthDate,
        hairColor: c.hairColor,
        code: c.code,
      )).toList(),
      createdAt: state.createdAt ?? now,
      updatedAt: now,
    );
  }

  ParentFormState toForm(ParentRecord record) {
    return ParentFormState(
      id: record.id,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      firstName: record.firstName,
      lastName: record.lastName,
      email: record.email,
      phone: record.phone,
      birthDate: record.birthDate,
      documentId: record.documentId,
      relationship: record.relationship,
      gender: record.gender,
      contactChannels: record.contactChannels.toSet(),
      isMarried: record.isMarried,
      occupation: record.occupation,
      observations: record.observations,
      children: record.children.map((c) => ChildFormState(
        id: c.id,
        firstName: c.firstName,
        lastName: c.lastName,
        age: c.age,
        birthDate: c.birthDate,
        hairColor: c.hairColor,
        code: c.code,
        errors: const {},
      )).toList(),
      errors: const {},
    );
  }
}