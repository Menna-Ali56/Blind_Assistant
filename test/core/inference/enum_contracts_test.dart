import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/inference/coded_enum.dart';
import 'package:baseer/core/inference/inference_results.dart';
import 'package:flutter_test/flutter_test.dart';

import '../network/contract_files.dart';

void main() {
  test('every enum maps an unknown value to unknown', () {
    expect(VoiceIntent.fromCode('NEW'), VoiceIntent.unknown);
    expect(MobileAction.fromCode(null), MobileAction.unknown);
    expect(FacialExpression.fromCode('NEW'), FacialExpression.unknown);
    expect(HapticPattern.fromCode('NEW'), HapticPattern.unknown);
  });

  test('enum codes match the contract file', () {
    final contract = readContract('enums.json')! as Map<String, dynamic>;
    List<String> codes(List<CodedEnum> values) =>
        values.map((value) => value.code).where((c) => c.isNotEmpty).toList();

    expect(codes(VoiceIntent.values), contract['VoiceIntent']);
    expect(codes(MobileAction.values), contract['MobileAction']);
    expect(codes(FacialExpression.values), contract['FacialExpression']);
    expect(codes(HapticPattern.values), contract['HapticPattern']);
  });

  test('unknown voice intent is not silent', () {
    final json = {
      'userInput': 'x',
      'detectedIntent': 'NEW',
      'confidence': 0.9,
      'spokenResponse': 'x',
      'actionToTriggerOnMobile': 'OPEN_CAMERA_OCR',
    };
    final failure = const ExceptionToFailureMapper().map(
      _thrownBy(() => VoiceCommandResult.fromJson(json)),
    );

    expect(failure.messageKey, ErrorCodeRegistry.unknownMessageKey);
  });
}

Object _thrownBy(void Function() action) {
  try {
    action();
  } catch (error) {
    return error;
  }
  throw StateError('nothing was thrown');
}
