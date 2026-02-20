String? emailValidator(String? value) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return 'Email obligatorio';
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!emailRegex.hasMatch(v)) return 'Email inválido';
  return null;
}