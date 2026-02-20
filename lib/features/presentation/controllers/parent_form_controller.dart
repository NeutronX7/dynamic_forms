import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../forms/domain/usecases/validate_parent_usecase.dart';

class ParentFormState {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final DateTime? birthDate;
  final String documentId;

  final Map<String, String?> errors;

  const ParentFormState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.birthDate,
    this.documentId = '',
    this.errors = const {},
  });

  ParentFormState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    DateTime? birthDate,
    String? documentId,
    Map<String, String?>? errors,
  }) {
    return ParentFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      documentId: documentId ?? this.documentId,
      errors: errors ?? this.errors,
    );
  }
}
class ParentFormController extends Notifier<ParentFormState> {
  late final ValidateParentUseCase _validate;

  @override
  ParentFormState build() {
    _validate = ValidateParentUseCase();
    return const ParentFormState();
  }

  void setFirstName(String v) => state = state.copyWith(firstName: v);
  void setLastName(String v) => state = state.copyWith(lastName: v);
  void setEmail(String v) => state = state.copyWith(email: v);
  void setPhone(String v) => state = state.copyWith(phone: v);
  void setBirthDate(DateTime v) => state = state.copyWith(birthDate: v);
  void setDocumentId(String v) => state = state.copyWith(documentId: v);

  bool validate() {
    final result = _validate(
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      phone: state.phone,
      documentId: state.documentId,
      birthDate: state.birthDate,
    );
    state = state.copyWith(errors: result.errors);
    return result.isValid;
  }
}


final parentFormControllerProvider =
NotifierProvider<ParentFormController, ParentFormState>(ParentFormController.new);
