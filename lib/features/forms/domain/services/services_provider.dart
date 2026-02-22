import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'age_service.dart';
import 'child_code_service.dart';

final ageServiceProvider = Provider<AgeService>((ref) => AgeService());
final childCodeServiceProvider = Provider<ChildCodeService>((ref) => ChildCodeService());