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
  }) {
    final errors = <String, String?>{
      'firstName': requiredValidator(firstName, message: 'Nombre obligatorio'),
      'lastName': requiredValidator(lastName, message: 'Apellido obligatorio'),
      'email': emailValidator(email),
      'phone': phoneValidator(phone),
      'documentId': requiredValidator(documentId, message: 'Documento obligatorio'),
      'birthDate': adultBirthDateValidator(birthDate),
    };

    return ParentValidationResult(errors);
  }
}