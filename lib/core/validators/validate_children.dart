String? requireValidateChildren(int children, {String message = 'Debe agregar al menos un hijo'}) {
  if (children <= 0) return message;
  return null;
}