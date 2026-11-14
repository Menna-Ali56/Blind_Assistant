import 'package:baseer/core/output/output.dart';
import 'package:flutter_test/flutter_test.dart';

import 'output_test_support.dart';

class _OrderChannel implements OutputChannel {
  _OrderChannel(this.events);

  final List<String> events;

  @override
  Future<void> speak(
    String text, {
    required String languageCode,
    required OutputPriority priority,
  }) async => events.add('speak:$text');

  @override
  Future<void> stop() async {}

  @override
  Future<void> haptic(OutputHaptic kind) async {}
}

class _EventFocus extends FakeAudioFocus {
  _EventFocus(this.log);

  final List<String> log;

  @override
  Future<void> acquire() async => log.add('acquire');

  @override
  Future<void> release() async => log.add('release');
}

void main() {
  test('acquire before first speech and release when queue empties', () async {
    final events = <String>[];
    final focus = _EventFocus(events);
    final coordinator = OutputCoordinator(_OrderChannel(events), focus: focus);

    coordinator
      ..submit(msg('one'))
      ..submit(msg('two'));
    await pumpEventQueue();
    await coordinator.dispose();

    expect(events, ['acquire', 'speak:one', 'speak:two', 'release']);
    await focus.close();
  });

  test('release is not called between consecutive messages', () async {
    final focus = FakeAudioFocus();
    final channel = FakeChannel();
    final coordinator = OutputCoordinator(channel, focus: focus);

    coordinator
      ..submit(msg('first'))
      ..submit(msg('second'));
    await pumpEventQueue();
    expect(focus.events, ['acquire']);

    channel.finish('first');
    await pumpEventQueue();
    expect(focus.events, ['acquire']);

    channel.finish('second');
    await pumpEventQueue();
    expect(focus.events, ['acquire', 'release']);
    await coordinator.dispose();
    await focus.close();
  });

  test('focus interruption stops current speech', () async {
    final focus = FakeAudioFocus();
    final channel = FakeChannel();
    final coordinator = OutputCoordinator(channel, focus: focus);

    coordinator.submit(msg('speaking'));
    await pumpEventQueue();
    focus.triggerInterruption();
    await pumpEventQueue();

    expect(channel.stops, 1);
    await coordinator.dispose();
    await focus.close();
  });
}
