import 'package:baseer/features/settings/domain/entities/app_settings.dart';
import 'package:baseer/features/voice_assistant/settings_commands/settings_commands.dart';
import 'package:flutter_test/flutter_test.dart';

import 'settings_commands_harness.dart';

/// Field positions in the settings props that have no voice command on purpose
const Set<int> documentedExclusions = {};

void main() {
  test('the five commands are listed with their ids', () async {
    final harness = SettingsCommandsHarness();
    final ids = harness.commands.map((c) => c.id).toList();
    await harness.dispose();

    expect(ids, [
      'settings.voice_rate.cycle',
      'settings.text_size.cycle',
      'settings.high_contrast.toggle',
      'settings.haptics.toggle',
      'settings.wake_word.toggle',
    ]);
    expect(ids, SettingsCommandIds.all);
  });

  test(
    'every settings field has a command or a documented exclusion',
    () async {
      final covered = {...documentedExclusions};

      for (final id in SettingsCommandIds.all) {
        final harness = SettingsCommandsHarness();
        final before = harness.cubit.state.settings.props;
        await harness.run(id);
        final after = harness.cubit.state.settings.props;
        await harness.dispose();

        covered.addAll([
          for (var i = 0; i < before.length; i++)
            if (before[i] != after[i]) i,
        ]);
      }

      final fields = const AppSettings().props.length;
      expect(covered, {for (var i = 0; i < fields; i++) i});
    },
  );
}
