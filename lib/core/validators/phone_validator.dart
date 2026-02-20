String? phoneValidator(String? value, {int minLength = 8}) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return 'Teléfono obligatorio';
  if (v.length < minLength) return 'Mínimo $minLength caracteres';
  return null;
}
