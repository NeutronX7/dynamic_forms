String? requiredValidator(String? value, {String message = 'Campo obligatorio'}) {
  if (value == null || value.trim().isEmpty) return message;
  return null;
}