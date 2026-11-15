import 'package:baseer/core/consent/consent.dart';
import 'package:baseer/core/execution/execution_feature.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const expected = <ExecutionFeature, ConsentScope?>{
    ExecutionFeature.currency: ConsentScope.imageUpload,
    ExecutionFeature.signOcr: ConsentScope.imageUpload,
    ExecutionFeature.expiryDate: ConsentScope.imageUpload,
    ExecutionFeature.documentReading: ConsentScope.imageUpload,
    ExecutionFeature.sceneDescription: ConsentScope.imageUpload,
    ExecutionFeature.visualQuestion: ConsentScope.imageUpload,
    ExecutionFeature.conversationalAsr: ConsentScope.audioUpload,
    ExecutionFeature.route: ConsentScope.locationShare,
    ExecutionFeature.obstacleAwareness: null,
    ExecutionFeature.voiceCommand: null,
  };

  test('consentScopeOf maps every execution feature', () {
    expect(expected.keys.toSet(), ExecutionFeature.values.toSet());
    for (final feature in ExecutionFeature.values) {
      expect(consentScopeOf(feature), expected[feature], reason: feature.name);
    }
  });

  test('GrantedConsent starts empty and updates scopes', () {
    final granted = GrantedConsent();

    for (final scope in ConsentScope.values) {
      expect(granted.allows(scope), isFalse);
    }

    granted.update({ConsentScope.imageUpload, ConsentScope.locationShare});

    expect(granted.allows(ConsentScope.imageUpload), isTrue);
    expect(granted.allows(ConsentScope.audioUpload), isFalse);
    expect(granted.allows(ConsentScope.locationShare), isTrue);
  });
}
