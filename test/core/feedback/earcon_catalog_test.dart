import 'package:baseer/core/feedback/earcon_catalog.dart';
import 'package:baseer/core/feedback/feedback_cue.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every cue has a usable spec', () {
    for (final cue in FeedbackCue.values) {
      final spec = EarconCatalog.of(cue);
      expect(spec.frequencyHz, greaterThan(0));
      expect(spec.tone, greaterThan(Duration.zero));
      expect(spec.volume, inInclusiveRange(0.1, 1.0));
      expect(spec.repeat, greaterThanOrEqualTo(1));
    }
  });

  test('no two cues sound the same', () {
    final sounds = FeedbackCue.values
        .map(EarconCatalog.of)
        .map((spec) => '${spec.frequencyHz}x${spec.repeat}')
        .toSet();
    expect(sounds.length, FeedbackCue.values.length);
  });

  test('emergency is the loudest and the most repeated', () {
    final emergency = EarconCatalog.of(FeedbackCue.warningEmergency);
    for (final cue in FeedbackCue.values) {
      final spec = EarconCatalog.of(cue);
      expect(emergency.volume, greaterThanOrEqualTo(spec.volume));
      expect(emergency.repeat, greaterThanOrEqualTo(spec.repeat));
    }
  });
}
