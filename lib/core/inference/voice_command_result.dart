import 'package:equatable/equatable.dart';

import '../errors/exceptions/contract_exception.dart';
import '../utils/json_fields.dart';
import 'mobile_action.dart';
import 'voice_intent.dart';

class VoiceCommandResult extends Equatable {
  const VoiceCommandResult({
    required this.userInput,
    required this.detectedIntent,
    required this.confidence,
    required this.spokenResponse,
    required this.action,
  });

  factory VoiceCommandResult.fromJson(Map<String, dynamic> json) {
    final intent = VoiceIntent.fromCode(
      optionalField<String>(json, 'detectedIntent'),
    );
    final action = MobileAction.fromCode(
      optionalField<String>(json, 'actionToTriggerOnMobile'),
    );
    if (intent == VoiceIntent.unknown || action == MobileAction.unknown) {
      throw const ContractException();
    }
    return VoiceCommandResult(
      userInput: requiredField<String>(json, 'userInput'),
      detectedIntent: intent,
      confidence: readConfidence(json),
      spokenResponse: requiredField<String>(json, 'spokenResponse'),
      action: action,
    );
  }

  final String userInput;
  final VoiceIntent detectedIntent;
  final double confidence;
  final String spokenResponse;
  final MobileAction action;

  @override
  List<Object?> get props => [
    userInput,
    detectedIntent,
    confidence,
    spokenResponse,
    action,
  ];
}
