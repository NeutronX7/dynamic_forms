import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../forms/domain/usecases/validate_parent_usecase.dart';

class ParentFormState {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final DateTime? birthDate;
  final String documentId;
  final String relationship;
  final String gender;
  final Set<String> contactChannels;


  final Map<String, String?> errors;

  const ParentFormState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.birthDate,
    this.documentId = '',
    this.relationship = 'Padre',
    this.gender = 'Prefiero no decir',
    this.contactChannels = const{},
    this.errors = const {},
  });

  ParentFormState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    DateTime? birthDate,
    String? documentId,
    String? relationship,
    String? gender,
    Set<String>? contactChannels,
    Map<String, String?>? errors,
  }) {
    return ParentFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      documentId: documentId ?? this.documentId,
      relationship: relationship ?? this.relationship,
      gender: gender ?? this.gender,
      contactChannels: contactChannels ?? this.contactChannels,
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
  void setRelationship(String v) => state = state.copyWith(relationship: v);
  void setGender(String v) => state = state.copyWith(gender: v);
  void toggleContactChannel(String channel) {
    final next = <String>{...state.contactChannels};

    if (next.contains(channel)) {
      next.remove(channel);
    } else {
      next.add(channel);
    }

    state = state.copyWith(contactChannels: next);
  }

  bool validate() {
    final result = _validate(
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      phone: state.phone,
      documentId: state.documentId,
      birthDate: state.birthDate,
      relationship: state.relationship,
      gender: state.gender,
      contactChannels: state.contactChannels,
    );
    state = state.copyWith(errors: result.errors);
    return result.isValid;
  }
}


final parentFormControllerProvider =
NotifierProvider<ParentFormController, ParentFormState>(ParentFormController.new);
