import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_defaults.dart';

/// Seed values from the model team and not tuned on real phone photos yet
class QualityThresholds extends Equatable {
  const QualityThresholds({
    required this.longSide,
    required this.minSharpness,
    required this.minBrightness,
    required this.maxBrightness,
    required this.timeout,
  });

  static const QualityThresholds seed = QualityThresholds(
    longSide: 640,
    minSharpness: 100,
    minBrightness: 50,
    maxBrightness: 240,
    timeout: AppDefaults.localInferenceTimeout,
  );

  final int longSide;
  final double minSharpness;
  final double minBrightness;
  final double maxBrightness;
  final Duration timeout;

  @override
  List<Object?> get props => [
    longSide,
    minSharpness,
    minBrightness,
    maxBrightness,
    timeout,
  ];
}
