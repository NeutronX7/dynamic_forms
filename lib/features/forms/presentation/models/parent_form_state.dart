import 'child_form_state.dart';

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
  final bool isMarried;
  final String occupation;
  final String observations;

  final List<ChildFormState> children;
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
    this.isMarried = false,
    this.occupation = '',
    this.observations = '',
    this.contactChannels = const {},
    this.children = const [],
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
    bool? isMarried,
    String? occupation,
    String? observations,
    List<ChildFormState>? children,
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
      isMarried: isMarried ?? this.isMarried,
      occupation: occupation ?? this.occupation,
      observations: observations ?? this.observations,
      children: children ?? this.children,
      errors: errors ?? this.errors,
    );
  }
}