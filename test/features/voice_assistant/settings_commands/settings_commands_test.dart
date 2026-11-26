import 'package:baseer/core/constants/app_languages.dart';
import 'package:baseer/features/settings/domain/entities/app_settings.dart';
import 'package:baseer/features/settings/presentation/cubit/settings_state.dart';
import 'package:baseer/features/voice_assistant/settings_commands/settings_commands.dart';
import 'package:flutter_test/flutter_test.dart';

import 'settings_commands_harness.dart';
import 'toggle_cases.dart';

void main() {
  late SettingsCommandsHarness harness;

  setUp(() => harness = SettingsCommandsHarness());
  tearDown(() => harness.dispose());

  AppSettings current() => harness.cubit.state.settings;

  test('voice rate command cycles and speaks the new name', () async {
    final spoken = await harness.run(SettingsCommandIds.voiceRateCycle);

    expect(current().voiceRate, VoiceRate.fast);
    expect(spoken, 'Voice speed is now Fast.');
  });

  test('text size command cycles and speaks the new name', () async {
    final spoken = await harness.run(SettingsCommandIds.textSizeCycle);

    expect(current().textScale, greaterThan(const AppSettings().textScale));
    expect(spoken, 'Text size is now Large.');
  });

  test('haptics command speaks the final value', () async {
    final spoken = await harness.run(SettingsCommandIds.hapticsToggle);

    expect(current().haptics, isFalse);
    expect(spoken, 'Vibration is now Off.');
  });

  test('a failed save is spoken with the value that came back', () async {
    harness.repository.failSave = true;

    final spoken = await harness.run(SettingsCommandIds.hapticsToggle);

    expect(current().haptics, isTrue);
    expect(spoken, 'Vibration is now On.');
  });

  test('speech uses the language from the callback', () async {
    final arabic = SettingsCommandsHarness(language: AppLanguages.arabic);

    final spoken = await arabic.run(SettingsCommandIds.hapticsToggle);
    await arabic.dispose();

    expect(spoken, 'الاهتزاز الآن متوقف.');
  });

  test('the cubit is loaded first when it was not loaded', () async {
    harness.repository.stored = const AppSettings(haptics: false);

    await harness.run(SettingsCommandIds.hapticsToggle, {
      SettingsCommandSlots.state: SettingsCommandSlots.on,
    });

    expect(harness.cubit.state.status, SettingsStatus.ready);
    expect(current().haptics, isTrue);
  });

  for (final toggle in toggleCases) {
    for (final initial in [true, false]) {
      test('${toggle.id} without a slot flips from $initial', () async {
        harness.repository.stored = toggle.write(const AppSettings(), initial);

        await harness.run(toggle.id);

        expect(toggle.read(current()), !initial);
      });

      for (final wanted in SettingsCommandSlots.wantedStates.entries) {
        test('${toggle.id} from $initial with ${wanted.key}', () async {
          harness.repository.stored = toggle.write(
            const AppSettings(),
            initial,
          );
          final slots = {SettingsCommandSlots.state: wanted.key};

          await harness.run(toggle.id, slots);

          expect(toggle.read(current()), wanted.value);
        });
      }
    }
  }

  test('an unknown state value changes nothing', () async {
    final spoken = await harness.run(SettingsCommandIds.hapticsToggle, {
      SettingsCommandSlots.state: 'maybe',
    });

    expect(current().haptics, isTrue);
    expect(spoken, 'Vibration is now On.');
  });
}
