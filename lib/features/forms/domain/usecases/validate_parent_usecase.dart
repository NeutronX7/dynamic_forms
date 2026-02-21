import 'package:dynamic_forms/core/validators/validate_children.dart';

import '../../../../core/validators/validators.dart';
import '../../presentation/models/child_form_state.dart';

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
    String? relationship,
    String? gender,
    Set<String>? contactChannels,
    String? occupation,
    required List<ChildFormState> children
  }) {
    final errors = <String, String?>{
      'firstName': requiredValidator(firstName, message: 'Nombre obligatorio'),
      'lastName': requiredValidator(lastName, message: 'Apellido obligatorio'),
      'email': emailValidator(email),
      'phone': phoneValidator(phone),
      'documentId': requiredValidator(documentId, message: 'Documento obligatorio'),
      'birthDate': adultBirthDateValidator(birthDate),
      'children': requireValidateChildren(children, message: 'Debe tener al menos un hijo')
    };

    return ParentValidationResult(errors);
  }
}