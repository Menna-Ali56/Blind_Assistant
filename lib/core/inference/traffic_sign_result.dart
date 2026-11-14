import 'package:equatable/equatable.dart';

import '../utils/json_fields.dart';

class TrafficSignResult extends Equatable {
  const TrafficSignResult({
    required this.signName,
    required this.spokenMeaning,
    required this.confidence,
  });

  factory TrafficSignResult.fromJson(Map<String, dynamic> json) =>
      TrafficSignResult(
        signName: requiredField<String>(json, 'signName'),
        spokenMeaning: requiredField<String>(json, 'spokenMeaning'),
        confidence: readConfidence(json),
      );

  final String signName;
  final String spokenMeaning;
  final double confidence;

  @override
  List<Object?> get props => [signName, spokenMeaning, confidence];
}
