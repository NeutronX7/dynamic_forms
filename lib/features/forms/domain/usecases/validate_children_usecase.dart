import '../../../../core/validators/validators.dart';

class ChildrenValidationResult {
  final Map<String, String?> errors;
  const ChildrenValidationResult(this.errors);

  bool get isValid => errors.values.every((e) => e == null);
}

class ValidateChildrenUsecase {
  ChildrenValidationResult call({
    required String firstName,
    required String lastName,
    required int age,
    required DateTime? birthDate,
    required String hairColor,
    String? gender
  }) {
    final errors = <String, String?>{
      'firstName': requiredValidator(firstName, message: 'Nombre obligatorio'),
      'lastName': requiredValidator(lastName, message: 'Apellido obligatorio'),
      'birthDate': childBirthdate(birthDate),
    };

    return ChildrenValidationResult(errors);
  }
}