class AgeService {
  int calcAge(DateTime birthDate, DateTime now) {
    var age = now.year - birthDate.year;
    final hadBirthday =
        (now.month > birthDate.month) ||
            (now.month == birthDate.month && now.day >= birthDate.day);
    if (!hadBirthday) age--;
    return age < 0 ? 0 : age;
  }
}