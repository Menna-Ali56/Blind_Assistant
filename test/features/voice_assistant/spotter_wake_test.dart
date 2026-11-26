import 'package:baseer/core/inference/mobile_action.dart';
import 'package:baseer/features/voice_assistant/spotter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/spotter_harness.dart';

void main() {
  late SpotterHarness h;

  setUp(() async {
    h = SpotterHarness();
    await h.controller.start();
  });

  test('commands are ignored until the wake phrase', () {
    h.hear(MobileAction.openCameraOcr.code);
    expect(h.sink.commands, isEmpty);
  });

  test('wake phrase opens the window and is never sent to the sink', () {
    h.hear(CommandKeywords.wakeId);
    expect(h.sink.commands, isEmpty);
    h.hear(MobileAction.openCameraOcr.code);
    expect(h.sink.commands.map((c) => c.id), [MobileAction.openCameraOcr.code]);
  });

  test('a weak wake phrase does not open the window', () {
    h.hear(CommandKeywords.wakeId, confidence: 0);
    h.hear(MobileAction.openCameraOcr.code);
    expect(h.sink.commands, isEmpty);
  });

  test('the window closes after one command', () {
    h.hear(CommandKeywords.wakeId);
    h.hear(MobileAction.openCameraOcr.code);
    h.hear(MobileAction.openCameraColor.code);
    expect(h.sink.commands, hasLength(1));
  });

  test('the window closes when time runs out', () {
    h.hear(CommandKeywords.wakeId);
    h.pass(SpotterLimits.wakeWindow);
    h.hear(MobileAction.openCameraOcr.code);
    expect(h.sink.commands, isEmpty);
  });

  test('without wake word commands pass and the wake phrase is ignored', () {
    h.wakeWord = false;
    h.hear(CommandKeywords.wakeId);
    h.hear(MobileAction.openCameraOcr.code);
    expect(h.sink.commands.map((c) => c.id), [MobileAction.openCameraOcr.code]);
  });

  test('stop closes the window', () async {
    h.hear(CommandKeywords.wakeId);
    await h.controller.stop();
    await h.controller.start();
    h.hear(MobileAction.openCameraOcr.code);
    expect(h.sink.commands, isEmpty);
  });
}
