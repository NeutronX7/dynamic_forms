import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/hive_providers.dart';
import '../../data/local/models/records.dart';
import '../../domain/usecases/validate_children_usecase.dart';
import '../../domain/usecases/validate_parent_usecase.dart';
import '../models/child_form_state.dart';
import '../models/parent_form_state.dart';

class ParentFormController extends Notifier<ParentFormState> {
  late final ValidateParentUseCase _validateParent;
  late final ValidateChildrenUsecase _validateChildren;

  String _newParentId() => DateTime.now().microsecondsSinceEpoch.toString();

  String _newChildId() => DateTime.now().microsecondsSinceEpoch.toString();

  String? _loadedParentId;

  bool isLoadedFor(String id) => _loadedParentId == id;

  int _calcAge(DateTime birthDate, DateTime now) {
    var age = now.year - birthDate.year;

    final hasHadBirthdayThisYear =
        (now.month > birthDate.month) ||
            (now.month == birthDate.month && now.day >= birthDate.day);

    if (!hasHadBirthdayThisYear) age--;

    return age < 0 ? 0 : age;
  }

  String _month2(DateTime? d) {
    if (d == null) return '';
    final m = d.month;
    return m < 10 ? '0$m' : '$m';
  }

  String _nthLetter(String s, int n) {
    final t = s.trim();
    if (t.isEmpty) return '';
    final chars = t.characters.toList();
    if (n < chars.length) return chars[n];
    return chars.first;
  }

  String _initialsNth({
    required String firstName,
    required String lastName,
    required int n,
  }) {
    final a = _nthLetter(firstName, n);
    final b = _nthLetter(lastName, n);
    return (a + b).toUpperCase();
  }

  String _buildChildCodeBase(ChildFormState child) {
    final childInit = _initialsNth(firstName: child.firstName, lastName: child.lastName, n: 0);
    final parentInit = _initialsNth(firstName: state.firstName, lastName: state.lastName, n: 0);
    final mm = _month2(child.birthDate);

    if (childInit.isEmpty || parentInit.isEmpty || mm.isEmpty) return '';
    return '$childInit-$parentInit-$mm';
  }

  String _buildChildCodeRecalc(ChildFormState child) {
    final childInit = _initialsNth(firstName: child.firstName, lastName: child.lastName, n: 1);
    final parentInit = _initialsNth(firstName: state.firstName, lastName: state.lastName, n: 1);
    final mm = _month2(child.birthDate);

    if (childInit.isEmpty || parentInit.isEmpty || mm.isEmpty) return '';
    return '$childInit-$parentInit-$mm';
  }

  bool _hasDuplicateCodes(List<ChildFormState> children) {
    final seen = <String>{};
    for (final c in children) {
      final code = c.code.trim();
      if (code.isEmpty) continue;
      if (!seen.add(code)) return true;
    }
    return false;
  }

  @override
  ParentFormState build() {
    _validateParent = ValidateParentUseCase();
    _validateChildren = ValidateChildrenUsecase();
    return const ParentFormState();
  }

  void setFirstName(String v) {
    state = state.copyWith(firstName: v);
    _recomputeAllChildrenCodes();
  }

  void setLastName(String v) {
    state = state.copyWith(lastName: v);
    _recomputeAllChildrenCodes();
  }

  ({List<ChildFormState> children, bool blocked}) _resolveDuplicateCodesOnce() {
    var next = state.children
        .map((c) => c.copyWith(code: _buildChildCodeBase(c)))
        .toList();

    final groups = <String, List<int>>{};
    for (var i = 0; i < next.length; i++) {
      final code = next[i].code.trim();
      if (code.isEmpty) continue;
      groups.putIfAbsent(code, () => []).add(i);
    }

    for (final entry in groups.entries) {
      final idxs = entry.value;
      if (idxs.length <= 1) continue;

      for (var k = 1; k < idxs.length; k++) {
        final i = idxs[k];
        final c = next[i];
        next[i] = c.copyWith(code: _buildChildCodeRecalc(c));
      }
    }

    final seen = <String>{};
    for (final c in next) {
      final code = c.code.trim();
      if (code.isEmpty) continue;
      if (!seen.add(code)) {
        return (children: next, blocked: true);
      }
    }

    return (children: next, blocked: false);
  }

  void _recomputeAllChildrenCodes() {
    final resolved = _resolveDuplicateCodesOnce();
    state = state.copyWith(children: resolved.children);
  }

  void setEmail(String v) => state = state.copyWith(email: v);
  void setPhone(String v) => state = state.copyWith(phone: v);
  bool _phoneNumberExists(String phone) {
    final phNmb = phone.trim();
    if (phNmb.isEmpty) return false;

    final box = ref.read(parentsBoxProvider);

    for (final p in box.values) {
      if (state.id.isNotEmpty && p.id == state.id) continue;

      if (p.phone.trim() == phNmb) return true;
    }

    return false;
  }

  void setBirthDate(DateTime v) => state = state.copyWith(birthDate: v);
  void setDocumentId(String v) => state = state.copyWith(documentId: v);
  bool _documentIdExistsInOtherParent(String documentId) {
    final doc = documentId.trim();
    if (doc.isEmpty) return false;

    final box = ref.read(parentsBoxProvider);

    for (final p in box.values) {
      if (state.id.isNotEmpty && p.id == state.id) continue;

      if (p.documentId.trim() == doc) return true;
    }

    return false;
  }

  void setRelationship(String v) => state = state.copyWith(relationship: v);
  void setGender(String v) => state = state.copyWith(gender: v);

  void toggleContactChannel(String channel) {
    final next = <String>{...?state.contactChannels};
    next.contains(channel) ? next.remove(channel) : next.add(channel);
    state = state.copyWith(contactChannels: next);
  }

  void setIsMarried(bool v) => state = state.copyWith(isMarried: v);
  void setOccupation(String v) => state = state.copyWith(occupation: v);
  void setObservations(String v) => state = state.copyWith(observations: v);

  void _recomputeChildCodeAt(int index) {
    _recomputeAllChildrenCodes();
  }

  void addChild() {
    final id = _newChildId();
    final newChild = ChildFormState.empty(id).copyWith(hairColor: 'Castaño');
    final withCode = newChild.copyWith(code: _buildChildCodeBase(newChild));
    state = state.copyWith(children: [...state.children, withCode]);
  }

  void removeChild(int index) {
    final next = [...state.children]..removeAt(index);
    state = state.copyWith(children: next);
  }

  void setChildFirstName(int index, String v) {
    final next = [...state.children];
    next[index] = next[index].copyWith(firstName: v);
    state = state.copyWith(children: next);
    _recomputeChildCodeAt(index);
  }

  void setChildLastName(int index, String v) {
    final next = [...state.children];
    next[index] = next[index].copyWith(lastName: v);
    state = state.copyWith(children: next);
    _recomputeChildCodeAt(index);
  }

  void setChildBirthDate(int index, DateTime v) {
    final now = DateTime.now();
    final age = _calcAge(v, now);

    final next = [...state.children];
    next[index] = next[index].copyWith(
      birthDate: v,
      age: age,
    );
    state = state.copyWith(children: next);

    _recomputeChildCodeAt(index);
  }

  void setChildAge(int index, int? v) {
    final next = [...state.children];
    next[index] = next[index].copyWith(age: v);
    state = state.copyWith(children: next);
  }

  void setChildHairColor(int index, String v) {
    final next = [...state.children];
    next[index] = next[index].copyWith(hairColor: v);
    state = state.copyWith(children: next);
  }

  Future<bool> save() async {
    final ok = validate();
    if (!ok) return false;

    final resolved = _resolveDuplicateCodesOnce();
    state = state.copyWith(children: resolved.children);

    if (_documentIdExistsInOtherParent(state.documentId)) {
      state = state.copyWith(errors: {
        ...state.errors,
        'documentId': 'Este documento ya está registrado en otro responsable',
      });
      return false;
    }

    if (_phoneNumberExists(state.phone)) {
      state = state.copyWith(errors: {
        ...state.errors,
        'phone': 'Este numero de teléfono ya está registrado',
      });
      return false;
    }

    if (_hasDuplicateCodes(state.children)) {
      state = state.copyWith(errors: {
        ...state.errors,
        'children': 'Hay código duplicado con dos hijos, si tiene 3 hijos, puede ingrsar otro nombre o usar otro apellido',
      });
      return false;
    }

    final now = DateTime.now();
    final parentId = state.id.isEmpty ? _newParentId() : state.id;

    final record = ParentRecord(
      id: parentId,
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      phone: state.phone,
      birthDate: state.birthDate,
      documentId: state.documentId,
      relationship: state.relationship,
      gender: state.gender,
      contactChannels: state.contactChannels.toList(),
      isMarried: state.isMarried,
      occupation: state.occupation,
      observations: state.observations,
      children: state.children.map((c) => ChildRecord(
        id: c.id,
        firstName: c.firstName,
        lastName: c.lastName,
        age: c.age,
        birthDate: c.birthDate,
        hairColor: c.hairColor,
        code: c.code,
      )).toList(),
      createdAt: state.createdAt ?? now,
      updatedAt: now,
    );

    final box = ref.read(parentsBoxProvider);
    await box.put(record.id, record);

    state = state.copyWith(
      id: parentId,
      createdAt: state.createdAt ?? now,
      updatedAt: now,
    );

    return true;
  }

  Future<void> loadForEdit(String parentId) async {
    final box = ref.read(parentsBoxProvider);
    final record = box.get(parentId);
    if (record == null) return;

    _loadedParentId = parentId;

    state = ParentFormState(
      id: record.id,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,

      firstName: record.firstName,
      lastName: record.lastName,
      email: record.email,
      phone: record.phone,
      birthDate: record.birthDate,
      documentId: record.documentId,

      // no obligatorios
      relationship: record.relationship,
      gender: record.gender,
      contactChannels: record.contactChannels.toSet(),
      isMarried: record.isMarried,
      occupation: record.occupation,
      observations: record.observations,

      children: record.children.map((c) {
        return ChildFormState(
          id: c.id,
          firstName: c.firstName,
          lastName: c.lastName,
          age: c.age,
          birthDate: c.birthDate,
          hairColor: c.hairColor,
          code: c.code,
          errors: const {},
        );
      }).toList(),

      errors: const {},
    );

    _recomputeAllChildrenCodes();
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

  void reset() {
    _loadedParentId = null;
    state = const ParentFormState();
  }
}