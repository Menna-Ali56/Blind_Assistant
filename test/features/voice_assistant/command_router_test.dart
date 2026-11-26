import 'package:baseer/core/output/output.dart';
import 'package:baseer/features/voice_assistant/voice_assistant.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../core/output/output_test_support.dart';
import 'voice_assistant_test_support.dart';

void main() {
  late RouterRig rig;

  setUp(() => rig = RouterRig());

  test('unknown id speaks the not understood text', () async {
    await rig.send('missing');

    expect(rig.channel.spoken, [voiceAssistantTextsFor('en').notUnderstood]);
  });

  test('unknown id uses the current language', () async {
    rig = RouterRig(language: 'ar');
    await rig.send('missing');

    expect(rig.channel.spoken, [voiceAssistantTextsFor('ar').notUnderstood]);
  });

  test('a successful run speaks its outcome', () async {
    rig.add(fakeCommand('read', spoken: 'done'));
    await rig.send('read');

    expect(rig.channel.spoken, ['done']);
  });

  test('a throwing handler is reported and not spoken', () async {
    rig.add(fakeCommand('bad', error: StateError('broke')));
    await rig.send('bad');

    expect(rig.channel.spoken, isEmpty);
    expect(rig.supervisor.lastReport?.source, CommandRouter.reportSource);
  });

  test('a repeated command never queues twice', () async {
    final busy = FakeChannel();
    final held = RouterRig(channel: busy);
    held.add(fakeCommand('read', spoken: 'done'));
    held.output.submit(msg('busy', priority: OutputPriority.critical));
    await pumpEventQueue();

    await held.send('read');
    await held.send('read');
    expect(held.output.pendingCount, 1);

    busy.finish('busy');
    await pumpEventQueue();
    expect(busy.spoken.where((text) => text == 'done'), hasLength(1));
  });
}
