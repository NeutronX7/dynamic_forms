String? adultBirthDateValidator(
    DateTime? birthDate, {
      int minAgeYears = 18,
      DateTime? now,
    }) {
  if (birthDate == null) return 'Fecha de nacimiento obligatoria';

  final today = (now ?? DateTime.now());
  final todayDate = DateTime(today.year, today.month, today.day);
  final b = DateTime(birthDate.year, birthDate.month, birthDate.day);

  if (b.isAfter(todayDate)) return 'La fecha no puede ser futura';

  int age = todayDate.year - b.year;
  final hadBirthdayThisYear =
      (todayDate.month > b.month) || (todayDate.month == b.month && todayDate.day >= b.day);
  if (!hadBirthdayThisYear) age -= 1;

  if (age < minAgeYears) return 'Debes ser mayor de edad ($minAgeYears+)';

  return null;
}

String? childBirthdate(
    DateTime? birthDate, {
      DateTime? now,
    }) {
  if (birthDate == null) return 'Fecha de nacimiento obligatoria';

  final today = (now ?? DateTime.now());
  final todayDate = DateTime(today.year, today.month, today.day);
  final b = DateTime(birthDate.year, birthDate.month, birthDate.day);

  if (b.isAfter(todayDate)) return 'La fecha no puede ser futura';

  return null;
}