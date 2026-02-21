class ChildFormState {
  final String firstName;
  final String lastName;
  final int? age;
  final DateTime? birthDate;
  final String hairColor;

  final Map<String, String?> errors;

  const ChildFormState({
    this.firstName = '',
    this.lastName = '',
    this.age,
    this.birthDate,
    this.hairColor = '',
    this.errors = const {},
  });

  factory ChildFormState.empty() => const ChildFormState();

  ChildFormState copyWith({
    String? firstName,
    String? lastName,
    int? age,
    DateTime? birthDate,
    String? hairColor,
    Map<String, String?>? errors,
  }) {
    return ChildFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      birthDate: birthDate ?? this.birthDate,
      hairColor: hairColor ?? this.hairColor,
      errors: errors ?? this.errors,
    );
  }
}