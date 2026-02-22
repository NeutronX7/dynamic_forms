import 'package:dynamic_forms/features/forms/presentation/controllers/parent_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/parent_form_state.dart';

final parentFormControllerProvider =
NotifierProvider<ParentFormController, ParentFormState>(
  ParentFormController.new,
);

final textControllerProvider =
Provider.autoDispose.family<TextEditingController, String>((ref, key) {
  final c = TextEditingController();
  ref.onDispose(c.dispose);
  return c;
});