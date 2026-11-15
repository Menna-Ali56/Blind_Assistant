import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/inference/inference_results.dart';
import 'package:baseer/core/network/api_envelope.dart';
import 'package:flutter_test/flutter_test.dart';

import '../network/contract_files.dart';

final Map<String, Object Function(Map<String, dynamic>)> _parsers = {
  'ocr': OcrResult.fromJson,
  'voice_command': VoiceCommandResult.fromJson,
  'scene_description': SceneDescriptionResult.fromJson,
  'currency_recognition': CurrencyResult.fromJson,
  'color_detection': ColorResult.fromJson,
  'traffic_sign_recognition': TrafficSignResult.fromJson,
  'face_expression': FaceExpressionResult.fromJson,
  'obstacle_detection': ObstacleResult.fromJson,
};

void main() {
  test('every success fixture is parsed by its model', () {
    final files = fixtureFiles('success');

    expect(files.length, _parsers.length);
    for (final file in files) {
      final name = file.uri.pathSegments.last.replaceAll('.json', '');
      expect(_parsers[name]!(readFixture(file)), isNotNull, reason: name);
    }
  });

  test('envelope parser reads data request id and meta', () {
    final ocr = readNamedFixture('success', 'ocr.json');
    final parsed = parseSuccess({
      'success': true,
      'data': ocr,
      'requestId': 'abc',
      'meta': {'modelName': 'ocr-fake', 'extra': 1},
      'newField': 1,
    }, OcrResult.fromJson);

    expect(parsed.requestId, 'abc');
    expect(parsed.meta!.modelName, 'ocr-fake');
  });

  test('missing field is a contract failure', () {
    expect(
      () => OcrResult.fromJson({'confidence': 0.9}),
      throwsA(isA<ContractException>()),
    );
  });
}
