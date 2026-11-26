import 'package:baseer/core/feedback/feedback_cue.dart';
import 'package:baseer/core/output/output.dart';
import 'package:flutter_test/flutter_test.dart';

import '../output/output_test_support.dart';
import 'feedback_test_support.dart';

void main() {
  test('each message plays the cue for its priority', () async {
    final cues = RecordingCueOutput();
    final coordinator = OutputCoordinator(
      FakeChannel(autoComplete: true),
      cues: cues,
    );
    for (final priority in OutputPriority.values) {
      coordinator.submit(msg('m', priority: priority));
      await pumpEventQueue();
    }
    final expected = OutputPriority.values
        .map(FeedbackCue.forPriority)
        .whereType<FeedbackCue>();
    expect(cues.cues, expected);
  });

  test('speech and the old haptic path still work', () async {
    final channel = FakeChannel(autoComplete: true);
    final coordinator = OutputCoordinator(channel, cues: RecordingCueOutput());
    coordinator.submit(msg('hello', haptic: OutputHaptic.heavy));
    await pumpEventQueue();
    expect(channel.spoken, ['hello']);
    expect(channel.haptics, [OutputHaptic.heavy]);
  });

  test('a failing cue is reported and speech goes on', () async {
    final errors = <Object>[];
    final channel = FakeChannel(autoComplete: true);
    final coordinator = OutputCoordinator(
      channel,
      cues: RecordingCueOutput(fails: true),
      onChannelError: (error, _) => errors.add(error),
    );
    coordinator.submit(msg('hello', priority: OutputPriority.critical));
    await pumpEventQueue();
    expect(channel.spoken, ['hello']);
    expect(errors, isNotEmpty);
  });

  test('stopping speech also cancels the cue', () async {
    final cues = RecordingCueOutput();
    final coordinator = OutputCoordinator(FakeChannel(), cues: cues);
    coordinator.submit(msg('long'));
    await pumpEventQueue();
    await coordinator.stopCurrent();
    expect(cues.cancels, 1);
  });
}
