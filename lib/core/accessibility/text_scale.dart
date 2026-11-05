import 'dart:math' as math;

import '../constants/app_defaults.dart';

double effectiveTextScale({required double system, required double extra}) {
  final ceiling = math.max(system, AppDefaults.maxTextScale);
  return (system * extra).clamp(system, ceiling).toDouble();
}
