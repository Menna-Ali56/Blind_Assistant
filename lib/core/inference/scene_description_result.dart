import 'package:equatable/equatable.dart';

import '../utils/json_fields.dart';

class SceneDescriptionResult extends Equatable {
  const SceneDescriptionResult({
    required this.description,
    required this.detectedObjects,
    required this.confidence,
  });

  factory SceneDescriptionResult.fromJson(Map<String, dynamic> json) =>
      SceneDescriptionResult(
        description: requiredField<String>(json, 'description'),
        detectedObjects: requiredStrings(json, 'detectedObjects'),
        confidence: readConfidence(json),
      );

  final String description;
  final List<String> detectedObjects;
  final double confidence;

  @override
  List<Object?> get props => [description, detectedObjects, confidence];
}
