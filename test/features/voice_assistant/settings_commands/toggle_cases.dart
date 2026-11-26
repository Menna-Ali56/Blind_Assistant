import 'package:baseer/features/settings/domain/entities/app_settings.dart';
import 'package:baseer/features/voice_assistant/settings_commands/settings_commands.dart';

class ToggleCase {
  const ToggleCase(this.id, this.read, this.write);

  final String id;
  final bool Function(AppSettings settings) read;
  final AppSettings Function(AppSettings settings, bool value) write;
}

final List<ToggleCase> toggleCases = [
  ToggleCase(
    SettingsCommandIds.highContrastToggle,
    (s) => s.highContrast,
    (s, v) => s.copyWith(highContrast: v),
  ),
  ToggleCase(
    SettingsCommandIds.hapticsToggle,
    (s) => s.haptics,
    (s, v) => s.copyWith(haptics: v),
  ),
  ToggleCase(
    SettingsCommandIds.wakeWordToggle,
    (s) => s.wakeWord,
    (s, v) => s.copyWith(wakeWord: v),
  ),
];
