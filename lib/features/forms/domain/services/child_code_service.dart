import 'package:flutter/material.dart';
import '../../presentation/models/child_form_state.dart';

class ChildCodeService {
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

  String _initialsNth({required String firstName, required String lastName, required int n}) {
    final a = _nthLetter(firstName, n);
    final b = _nthLetter(lastName, n);
    return (a + b).toUpperCase();
  }

  String buildBase({
    required ChildFormState child,
    required String parentFirstName,
    required String parentLastName,
  }) {
    final childInit = _initialsNth(firstName: child.firstName, lastName: child.lastName, n: 0);
    final parentInit = _initialsNth(firstName: parentFirstName, lastName: parentLastName, n: 0);
    final mm = _month2(child.birthDate);
    if (childInit.isEmpty || parentInit.isEmpty || mm.isEmpty) return '';
    return '$childInit-$parentInit-$mm';
  }

  String buildRecalc({
    required ChildFormState child,
    required String parentFirstName,
    required String parentLastName,
  }) {
    final childInit = _initialsNth(firstName: child.firstName, lastName: child.lastName, n: 1);
    final parentInit = _initialsNth(firstName: parentFirstName, lastName: parentLastName, n: 1);
    final mm = _month2(child.birthDate);
    if (childInit.isEmpty || parentInit.isEmpty || mm.isEmpty) return '';
    return '$childInit-$parentInit-$mm';
  }

  ({List<ChildFormState> children, bool blocked}) resolveDuplicatesOnce({
    required List<ChildFormState> children,
    required String parentFirstName,
    required String parentLastName,
  }) {
    var next = children
        .map((c) => c.copyWith(code: buildBase(child: c, parentFirstName: parentFirstName, parentLastName: parentLastName)))
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
        next[i] = c.copyWith(
          code: buildRecalc(child: c, parentFirstName: parentFirstName, parentLastName: parentLastName),
        );
      }
    }

    final seen = <String>{};
    for (final c in next) {
      final code = c.code.trim();
      if (code.isEmpty) continue;
      if (!seen.add(code)) return (children: next, blocked: true);
    }

    return (children: next, blocked: false);
  }

  bool hasDuplicateCodes(List<ChildFormState> children) {
    final seen = <String>{};
    for (final c in children) {
      final code = c.code.trim();
      if (code.isEmpty) continue;
      if (!seen.add(code)) return true;
    }
    return false;
  }
}