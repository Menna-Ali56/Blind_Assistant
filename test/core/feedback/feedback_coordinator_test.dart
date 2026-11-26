import 'package:baseer/core/feedback/feedback_coordinator.dart';
import 'package:baseer/core/feedback/feedback_cue.dart';
import 'package:flutter_test/flutter_test.dart';

import 'feedback_test_support.dart';

void main() {
  test('play and cancel reach every output', () async {
    final first = RecordingCueOutput();
    final second = RecordingCueOutput();
    final coordinator = FeedbackCoordinator([first, second]);
    await coordinator.play(FeedbackCue.done);
    await coordinator.cancel();
    for (final output in [first, second]) {
      expect(output.cues, [FeedbackCue.done]);
      expect(output.cancels, 1);
    }
  });

  test('one failing output does not block the others', () async {
    final errors = <Object>[];
    final good = RecordingCueOutput();
    final coordinator = FeedbackCoordinator([
      RecordingCueOutput(fails: true),
      good,
    ], onError: (error, _) => errors.add(error));
    await coordinator.play(FeedbackCue.error);
    expect(good.cues, [FeedbackCue.error]);
    expect(errors.length, 1);
  });

  test('a throwing error callback never escapes', () async {
    final coordinator = FeedbackCoordinator([
      RecordingCueOutput(fails: true),
    ], onError: (_, _) => throw StateError('callback'));
    await coordinator.play(FeedbackCue.error);
  });
}
