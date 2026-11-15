import 'package:equatable/equatable.dart';

import '../utils/json_fields.dart';
import 'haptic_pattern.dart';

class ObstacleResult extends Equatable {
  const ObstacleResult({
    required this.hazardDetected,
    required this.hapticAlertPattern,
    required this.spokenWarning,
    required this.confidence,
    this.obstacleType,
    this.distanceMeters,
  });

  factory ObstacleResult.fromJson(Map<String, dynamic> json) => ObstacleResult(
    hazardDetected: requiredField<bool>(json, 'hazardDetected'),
    hapticAlertPattern: HapticPattern.fromCode(
      optionalField<String>(json, 'hapticAlertPattern'),
    ),
    spokenWarning: requiredField<String>(json, 'spokenWarning'),
    confidence: readConfidence(json),
    obstacleType: optionalField<String>(json, 'obstacleType'),
    distanceMeters: optionalNumber(json, 'distanceMeters'),
  );

  final bool hazardDetected;
  final HapticPattern hapticAlertPattern;
  final String spokenWarning;
  final double confidence;
  final String? obstacleType;
  final double? distanceMeters;

  @override
  List<Object?> get props => [
    hazardDetected,
    hapticAlertPattern,
    spokenWarning,
    confidence,
    obstacleType,
    distanceMeters,
  ];
}
