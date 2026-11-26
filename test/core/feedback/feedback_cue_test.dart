import 'package:baseer/core/feedback/feedback.dart';
import 'package:baseer/core/output/output_priority.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ambient priority has no cue', () {
    expect(FeedbackCue.forPriority(OutputPriority.low), isNull);
  });

  test('each higher priority maps to a stronger warning cue', () {
    expect(
      FeedbackCue.forPriority(OutputPriority.normal),
      FeedbackCue.warningInfo,
    );
    expect(
      FeedbackCue.forPriority(OutputPriority.high),
      FeedbackCue.warningUrgent,
    );
    expect(
      FeedbackCue.forPriority(OutputPriority.critical),
      FeedbackCue.warningEmergency,
    );
  });

  test('the catalog covers every cue', () {
    expect(hapticCatalog.keys.toSet(), FeedbackCue.values.toSet());
  });

  test('intensity falls back to medium for unknown codes', () {
    expect(HapticIntensity.fromCode('nope'), HapticIntensity.medium);
    expect(HapticIntensity.fromCode('high'), HapticIntensity.high);
  });
}
