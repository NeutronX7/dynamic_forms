import 'package:dynamic_forms/features/forms/presentation/models/child_form_state.dart';

String? requireValidateChildren(List<ChildFormState> children, {String message = 'Debe agregar al menos un hijo'}) {
  if (children.isEmpty) return message;
  return null;
}