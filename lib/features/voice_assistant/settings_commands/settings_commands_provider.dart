import '../../../core/output/output_module.dart';
import '../../settings/domain/entities/app_settings.dart';
import '../../settings/presentation/cubit/settings_cubit.dart';
import '../../settings/presentation/cubit/settings_state.dart';
import '../../settings/presentation/cubit/text_size_step.dart';
import '../../settings/presentation/settings_strings.dart';
import '../domain/entities/command_outcome.dart';
import '../domain/entities/voice_command.dart';
import '../domain/repositories/command_provider.dart';
import 'settings_command_ids.dart';
import 'settings_command_slots.dart';
import 'texts/settings_command_texts_lookup.dart';

typedef _Change =
    Future<void> Function(SettingsCubit cubit, Map<String, String> slots);
typedef _Flip = Future<void> Function(SettingsCubit cubit);
typedef _Label = String Function(SettingsStrings texts);
typedef _Value = String Function(SettingsStrings texts, AppSettings settings);

class SettingsCommands implements CommandProvider {
  SettingsCommands({
    required this._cubit,
    this._languageCode = defaultLanguageCode,
  });

  final SettingsCubit Function() _cubit;
  final String Function() _languageCode;

  @override
  late final List<VoiceCommand> commands = [
    _cycle(
      SettingsCommandIds.voiceRateCycle,
      (c) => c.cycleVoiceRate(),
      (t) => t.voiceRate,
      (t, s) => t.voiceRateValue(s.voiceRate),
    ),
    _cycle(
      SettingsCommandIds.textSizeCycle,
      (c) => c.cycleTextSize(),
      (t) => t.textSize,
      (t, s) => t.textSizeValue(TextSizeStep.fromScale(s.textScale)),
    ),
    _toggle(
      SettingsCommandIds.highContrastToggle,
      (s) => s.highContrast,
      (c) => c.toggleHighContrast(),
      (t) => t.highContrast,
    ),
    _toggle(
      SettingsCommandIds.hapticsToggle,
      (s) => s.haptics,
      (c) => c.toggleHaptics(),
      (t) => t.haptics,
    ),
    _toggle(
      SettingsCommandIds.wakeWordToggle,
      (s) => s.wakeWord,
      (c) => c.toggleWakeWord(),
      (t) => t.wakeWord,
    ),
  ];

  VoiceCommand _cycle(String id, _Flip flip, _Label label, _Value value) =>
      _command(id, (cubit, _) => flip(cubit), label, value);

  VoiceCommand _toggle(
    String id,
    bool Function(AppSettings settings) read,
    _Flip flip,
    _Label label,
  ) => _command(
    id,
    (cubit, slots) async {
      final current = read(cubit.state.settings);
      if (SettingsCommandSlots.shouldFlip(slots, current: current)) {
        await flip(cubit);
      }
    },
    label,
    (t, s) => t.onOff(read(s)),
  );

  /// Speaks the value read after the change because a failed save puts the old value back
  VoiceCommand _command(
    String id,
    _Change change,
    _Label label,
    _Value value,
  ) => VoiceCommand(
    id: id,
    run: (slots) async {
      final cubit = _cubit();
      if (cubit.state.status != SettingsStatus.ready) await cubit.load();
      await change(cubit, slots);
      final language = _languageCode();
      final texts = SettingsStrings.of(language);
      return CommandOutcome(
        spoken: settingsCommandTextsFor(
          language,
        ).changed(label(texts), value(texts, cubit.state.settings)),
      );
    },
  );
}
