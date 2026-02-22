import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/validate_children_usecase.dart';
import '../../domain/usecases/validate_parent_usecase.dart';
import '../models/child_form_state.dart';
import '../models/parent_form_state.dart';

class ParentFormController extends Notifier<ParentFormState> {
  late final ValidateParentUseCase _validateParent;
  late final ValidateChildrenUsecase _validateChildren;

  @override
  ParentFormState build() {
    _validateParent = ValidateParentUseCase();
    _validateChildren = ValidateChildrenUsecase();
    return const ParentFormState();
  }

  void setFirstName(String v) => state = state.copyWith(firstName: v);
  void setLastName(String v) => state = state.copyWith(lastName: v);
  void setEmail(String v) => state = state.copyWith(email: v);
  void setPhone(String v) => state = state.copyWith(phone: v);
  void setBirthDate(DateTime v) => state = state.copyWith(birthDate: v);
  void setDocumentId(String v) => state = state.copyWith(documentId: v);

  void setRelationship(String v) => state = state.copyWith(relationship: v);
  void setGender(String v) => state = state.copyWith(gender: v);

  void toggleContactChannel(String channel) {
    final next = <String>{...state.contactChannels};
    next.contains(channel) ? next.remove(channel) : next.add(channel);
    state = state.copyWith(contactChannels: next);
  }

  void setIsMarried(bool v) => state = state.copyWith(isMarried: v);
  void setOccupation(String v) => state = state.copyWith(occupation: v);
  void setObservations(String v) => state = state.copyWith(observations: v);

  void addChild() {
    final newChild = ChildFormState.empty();
    state = state.copyWith(children: [...state.children, newChild]);
  }

  void removeChild(int index) {
    final next = [...state.children]..removeAt(index);
    state = state.copyWith(children: next);
  }

  void setChildFirstName(int index, String v) {
    final next = [...state.children];
    next[index] = next[index].copyWith(firstName: v);
    state = state.copyWith(children: next);
  }

  void setChildLastName(int index, String v) {
    final next = [...state.children];
    next[index] = next[index].copyWith(lastName: v);
    state = state.copyWith(children: next);
  }

  void setChildAge(int index, int? v) {
    final next = [...state.children];
    next[index] = next[index].copyWith(age: v);
    state = state.copyWith(children: next);
  }

  void setChildBirthDate(int index, DateTime v) {
    final next = [...state.children];
    next[index] = next[index].copyWith(birthDate: v);
    state = state.copyWith(children: next);
  }

  void setChildHairColor(int index, String v) {
    final next = [...state.children];
    next[index] = next[index].copyWith(hairColor: v);
    state = state.copyWith(children: next);
  }

  bool validate() {
    final parentResult = _validateParent(
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      phone: state.phone,
      documentId: state.documentId,
      birthDate: state.birthDate,
      relationship: state.relationship,
      gender: state.gender,
      contactChannels: state.contactChannels,
      occupation: state.occupation,
      children: state.children.length,
    );

    final updatedChildren = state.children.map((c) {
      final r = _validateChildren(
        firstName: c.firstName,
        lastName: c.lastName,
        age: c.age,
        birthDate: c.birthDate,
        hairColor: c.hairColor,
      );
      return c.copyWith(errors: r.errors);
    }).toList();

    final childrenValid = updatedChildren.every((c) => c.errors.values.every((e) => e == null));

    state = state.copyWith(
      errors: parentResult.errors,
      children: updatedChildren,
    );

    return parentResult.isValid && childrenValid;
  }
}