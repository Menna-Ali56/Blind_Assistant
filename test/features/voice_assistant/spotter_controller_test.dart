import 'package:baseer/core/inference/mobile_action.dart';
import 'package:baseer/core/navigation/app_destination.dart';
import 'package:baseer/features/voice_assistant/navigation_commands.dart';
import 'package:baseer/features/voice_assistant/settings_commands/settings_commands.dart';
import 'package:baseer/features/voice_assistant/spotter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/spotter_harness.dart';

void main() {
  test('a camera command above the threshold reaches the sink', () async {
    final h = SpotterHarness(wakeWord: false);
    await h.controller.start();
    h.hear(MobileAction.openCameraOcr.code);

    final command = h.sink.commands.single;
    expect(command.id, MobileAction.openCameraOcr.code);
    expect(command.slots[SlotKeys.locale], CommandLocale.enUs.code);
  });

  test(
    'navigation and settings toggle commands dispatch string id and slots',
    () async {
      final h = SpotterHarness(wakeWord: false);
      await h.controller.start();
      h.hear(openCommandId(AppDestination.read.name));
      h.hear(
        SettingsCommandIds.highContrastToggle,
        locale: CommandLocale.arEg,
        slots: const {SlotKeys.state: SlotKeys.on},
      );

      expect(h.sink.commands[0].id, 'open.read');
      expect(h.sink.commands[1].id, SettingsCommandIds.highContrastToggle);
      expect(
        h.sink.commands[1].slots[SlotKeys.locale],
        CommandLocale.arEg.code,
      );
      expect(h.sink.commands[1].slots[SlotKeys.state], SlotKeys.on);
    },
  );

  test('low confidence is dropped', () async {
    final h = SpotterHarness(wakeWord: false);
    await h.controller.start();
    h.hear(MobileAction.openCameraOcr.code, confidence: 0);
    expect(h.sink.commands, isEmpty);
  });

  test('an unknown keyword is dropped', () async {
    final h = SpotterHarness(wakeWord: false);
    await h.controller.start();
    h.spotter.emit('not a command', SpotterHarness.sure);
    expect(h.sink.commands, isEmpty);
  });

  test('nothing is heard before start or after stop', () async {
    final h = SpotterHarness(wakeWord: false);
    h.hear(MobileAction.openCameraOcr.code);
    await h.controller.start();
    await h.controller.stop();
    h.hear(MobileAction.openCameraOcr.code);
    expect(h.sink.commands, isEmpty);
    expect(h.spotter.stopCalls, 1);
  });

  test('start twice listens once', () async {
    final h = SpotterHarness(wakeWord: false);
    await h.controller.start();
    await h.controller.start();
    h.hear(MobileAction.openCameraOcr.code);
    expect(h.spotter.startCalls, 1);
    expect(h.sink.commands, hasLength(1));
  });

  test('dispose cancels the subscription', () async {
    final h = SpotterHarness(wakeWord: false);
    await h.controller.start();
    await h.controller.dispose();
    expect(h.spotter.hasListener, isFalse);
  });

  test('a failing sink never throws and is reported', () async {
    final h = SpotterHarness(wakeWord: false, failingSink: true);
    await h.controller.start();
    h.hear(MobileAction.openCameraOcr.code);
    expect(h.errors, hasLength(1));
  });

  test('a failing spotter start is reported and cleaned up', () async {
    final h = SpotterHarness(failOnStart: true);
    await h.controller.start();
    expect(h.errors, hasLength(1));
    expect(h.spotter.hasListener, isFalse);
  });
}
