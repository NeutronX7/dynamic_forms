import '../../../../core/validators/validators.dart';

class ParentValidationResult {
  final Map<String, String?> errors;
  const ParentValidationResult(this.errors);

  bool get isValid => errors.values.every((e) => e == null);
}

class ValidateParentUseCase {
  ParentValidationResult call({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String documentId,
    required DateTime? birthDate,
    required String relationship,
    required String gender,
    required Set<String> contactChannels,
    required String occupation,
  }) {
    final errors = <String, String?>{
      'firstName': requiredValidator(firstName, message: 'Nombre obligatorio'),
      'lastName': requiredValidator(lastName, message: 'Apellido obligatorio'),
      'email': emailValidator(email),
      'phone': phoneValidator(phone),
      'documentId': requiredValidator(documentId, message: 'Documento obligatorio'),
      'birthDate': adultBirthDateValidator(birthDate),
      'relationship': requiredValidator(relationship, message: 'Selecciona una relación'),
      'gender': requiredValidator(gender, message: 'Selecciona un género'),
      'contactChannels': contactChannels.isEmpty ? 'Selecciona un canal de contacto' : null,
      'occupation': requiredValidator(occupation, message: 'Selecciona una ocupación'),
    };

    return ParentValidationResult(errors);
  }
}