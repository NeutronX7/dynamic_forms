String? documentId13DigitsValidator(String value, {String message = 'Debe tener 13 dígitos'}) {
  final v = value.trim();
  if (v.isEmpty) return 'Documento obligatorio';

  if (!RegExp(r'^\d{13}$').hasMatch(v)) return message;

  return null;
}