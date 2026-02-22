class ChildFormState {
  final String id;
  final String firstName;
  final String lastName;
  final int? age;
  final DateTime? birthDate;
  final String hairColor;
  final String code;

  final Map<String, String?> errors;

  const ChildFormState({
    required this.id,
    this.firstName = '',
    this.lastName = '',
    this.age,
    this.birthDate,
    this.hairColor = '',
    this.code = '',
    this.errors = const {},
  });

  factory ChildFormState.empty(String id) => ChildFormState(id: id);

  ChildFormState copyWith({
    String? id,
    String? firstName,
    String? lastName,
    int? age,
    DateTime? birthDate,
    String? hairColor,
    String? code,
    Map<String, String?>? errors,
  }) {
    return ChildFormState(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      birthDate: birthDate ?? this.birthDate,
      hairColor: hairColor ?? this.hairColor,
      code: code ?? this.code,
      errors: errors ?? this.errors,
    );
  }
}