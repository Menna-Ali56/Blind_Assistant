import 'package:baseer/core/inference/mobile_action.dart';
import 'package:baseer/core/navigation/app_destination.dart';
import 'package:baseer/features/voice_assistant/navigation_commands.dart';
import 'package:baseer/features/voice_assistant/settings_commands/settings_commands.dart';
import 'package:baseer/features/voice_assistant/spotter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/spotter_harness.dart';

void main() {
  final catalog = CommandCatalog(CommandKeywords.table);

  test('every group has keywords in every locale', () {
    for (final group in CommandKeywords.table) {
      for (final locale in CommandLocale.values) {
        expect(group.phrases[locale], isNotEmpty);
      }
    }
  });

  test('no keyword is used twice', () {
    final total = CommandKeywords.table
        .expand((g) => g.phrases.values)
        .expand((keywords) => keywords)
        .length;
    expect(catalog.entries.length, total);
  });

  test('every keyword finds its own command, locale, and slots', () {
    for (final group in CommandKeywords.table) {
      for (final locale in group.phrases.entries) {
        for (final keyword in locale.value) {
          final entry = catalog.lookup(keyword);
          expect(entry?.id, group.id);
          expect(entry?.locale, locale.key);
          expect(entry?.slots, group.slots);
        }
      }
    }
  });

  test('catalog covers navigation, settings, and camera ids', () {
    for (final dest in AppDestination.values) {
      expect(CommandKeywords.allIds, contains(openCommandId(dest.name)));
    }
    expect(
      CommandKeywords.allIds,
      contains(openCommandId(settingsCommandName)),
    );
    for (final id in SettingsCommandIds.all) {
      expect(CommandKeywords.allIds, contains(id));
    }
    for (final action in MobileAction.values.where(
      (a) => a != MobileAction.unknown,
    )) {
      expect(CommandKeywords.allIds, contains(action.code));
    }
  });

  test('toggle commands emit optional state slot on or off', () {
    final onPhrase = keywordFor(
      SettingsCommandIds.hapticsToggle,
      CommandLocale.enUs,
      const {SlotKeys.state: SlotKeys.on},
    );
    final offPhrase = keywordFor(
      SettingsCommandIds.hapticsToggle,
      CommandLocale.arEg,
      const {SlotKeys.state: SlotKeys.off},
    );
    expect(
      catalog.lookup(onPhrase)?.resolvedSlots[SlotKeys.state],
      SlotKeys.on,
    );
    expect(
      catalog.lookup(offPhrase)?.resolvedSlots[SlotKeys.state],
      SlotKeys.off,
    );
  });

  test('lookup ignores case and spacing', () {
    final keyword = keywordFor(MobileAction.openCameraOcr.code);
    expect(
      catalog.lookup('  ${keyword.toUpperCase()}  ')?.id,
      MobileAction.openCameraOcr.code,
    );
  });

  test('an unknown keyword gives nothing', () {
    expect(catalog.lookup('not a command'), isNull);
  });
}
