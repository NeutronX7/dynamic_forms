import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/hive_providers.dart';
import '../../data/mappers/parent_record_mapper.dart';
import '../../data/repositories/parents_repository.dart';
import '../../domain/services/services.dart';
import '../../domain/usecases/usecases.dart';
import '../models/states.dart';

class ParentFormController extends Notifier<ParentFormState> {
  late final ValidateParentUseCase _validateParent;
  late final ValidateChildrenUsecase _validateChildren;

  late final ParentsRepository _repo;
  late final AgeService _ageService;
  late final ChildCodeService _codeService;
  late final ParentRecordMapper _mapper;

  String? _loadedParentId;
  bool isLoadedFor(String id) => _loadedParentId == id;

  String _newParentId() => DateTime.now().microsecondsSinceEpoch.toString();
  String _newChildId() => DateTime.now().microsecondsSinceEpoch.toString();

  @override
  ParentFormState build() {
    _validateParent = ValidateParentUseCase();
    _validateChildren = ValidateChildrenUsecase();

    _repo = ref.read(parentsRepositoryProvider);
    _ageService = ref.read(ageServiceProvider);
    _codeService = ref.read(childCodeServiceProvider);
    _mapper = ParentRecordMapper();

    return const ParentFormState();
  }

  void setFirstName(String v) {
    state = state.copyWith(firstName: v);
    _recomputeCodes();
  }

  void setLastName(String v) {
    state = state.copyWith(lastName: v);
    _recomputeCodes();
  }

  void setEmail(String v) => state = state.copyWith(email: v);
  void setPhone(String v) => state = state.copyWith(phone: v);
  void setBirthDate(DateTime v) => state = state.copyWith(birthDate: v);
  void setDocumentId(String v) => state = state.copyWith(documentId: v);

  void setRelationship(String v) => state = state.copyWith(relationship: v);
  void setGender(String v) => state = state.copyWith(gender: v);
  void setIsMarried(bool v) => state = state.copyWith(isMarried: v);
  void setOccupation(String v) => state = state.copyWith(occupation: v);
  void setObservations(String v) => state = state.copyWith(observations: v);

  void toggleContactChannel(String channel) {
    final next = <String>{...state.contactChannels};
    next.contains(channel) ? next.remove(channel) : next.add(channel);
    state = state.copyWith(contactChannels: next);
  }

  void addChild() {
    final id = _newChildId();
    final newChild = ChildFormState.empty(id).copyWith(hairColor: 'Castaño');
    state = state.copyWith(children: [...state.children, newChild]);
    _recomputeCodes();
  }

  void removeChild(int index) {
    final next = [...state.children]..removeAt(index);
    state = state.copyWith(children: next);
    _recomputeCodes();
  }

  void setChildFirstName(int index, String v) => _patchChild(index, (c) => c.copyWith(firstName: v));
  void setChildLastName(int index, String v) => _patchChild(index, (c) => c.copyWith(lastName: v));
  void setChildHairColor(int index, String v) => _patchChild(index, (c) => c.copyWith(hairColor: v));

  void setChildBirthDate(int index, DateTime v) {
    final age = _ageService.calcAge(v, DateTime.now());
    _patchChild(index, (c) => c.copyWith(birthDate: v, age: age));
  }

  void _patchChild(int index, ChildFormState Function(ChildFormState) update) {
    final next = [...state.children];
    next[index] = update(next[index]);
    state = state.copyWith(children: next);
    _recomputeCodes();
  }

  void _recomputeCodes() {
    final resolved = _codeService.resolveDuplicatesOnce(
      children: state.children,
      parentFirstName: state.firstName,
      parentLastName: state.lastName,
    );

    state = state.copyWith(children: resolved.children);

    if (resolved.blocked) {
      state = state.copyWith(errors: {
        ...state.errors,
        'children': 'Hay códigos duplicados incluso después del recálculo.',
      });
    }
  }

  Future<bool> save() async {
    final ok = validate();
    if (!ok) return false;

    final resolved = _codeService.resolveDuplicatesOnce(
      children: state.children,
      parentFirstName: state.firstName,
      parentLastName: state.lastName,
    );
    state = state.copyWith(children: resolved.children);

    if (resolved.blocked) {
      state = state.copyWith(errors: {
        ...state.errors,
        'children': 'Hay códigos duplicados incluso después del recálculo.',
      });
      return false;
    }

    if (_repo.documentIdExists(state.documentId, excludeParentId: state.id.isEmpty ? null : state.id)) {
      state = state.copyWith(errors: {
        ...state.errors,
        'documentId': 'Este documento ya está registrado en otro responsable',
      });
      return false;
    }

    if (_repo.phoneExists(state.phone, excludeParentId: state.id.isEmpty ? null : state.id)) {
      state = state.copyWith(errors: {
        ...state.errors,
        'phone': 'Este número de teléfono ya está registrado',
      });
      return false;
    }

    if (_codeService.hasDuplicateCodes(state.children)) {
      state = state.copyWith(errors: {
        ...state.errors,
        'children': 'Hay código duplicado entre hijos.',
      });
      return false;
    }

    final now = DateTime.now();
    final parentId = state.id.isEmpty ? _newParentId() : state.id;

    final record = _mapper.fromForm(state: state, id: parentId, now: now);
    await _repo.upsert(record);

    state = state.copyWith(
      id: parentId,
      createdAt: state.createdAt ?? now,
      updatedAt: now,
    );

    return true;
  }

  Future<void> loadForEdit(String parentId) async {
    final record = _repo.getById(parentId);
    if (record == null) return;

    _loadedParentId = parentId;
    state = _mapper.toForm(record);
    _recomputeCodes();
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

    state = state.copyWith(errors: parentResult.errors, children: updatedChildren);

    return parentResult.isValid && childrenValid;
  }

  void reset() {
    _loadedParentId = null;
    state = const ParentFormState();
  }
}