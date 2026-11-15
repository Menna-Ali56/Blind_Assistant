import '../../../../core/constants/app_defaults.dart';
import '../../domain/entities/app_settings.dart';

abstract final class AppSettingsMapper {
  static const int schemaVersion = 1;

  static Map<String, Object?> toJson(AppSettings settings) => {
    'version': schemaVersion,
    'voiceRate': settings.voiceRate.name,
    'textScale': settings.textScale,
    'highContrast': settings.highContrast,
    'haptics': settings.haptics,
    'wakeWord': settings.wakeWord,
  };

  static AppSettings fromJson(Map<String, Object?> json) {
    const defaults = AppSettings();
    return AppSettings(
      voiceRate:
          _enumByName(json['voiceRate'], VoiceRate.values) ??
          defaults.voiceRate,
      textScale: _scale(json['textScale']) ?? defaults.textScale,
      highContrast: _flag(json['highContrast'], defaults.highContrast),
      haptics: _flag(json['haptics'], defaults.haptics),
      wakeWord: _flag(json['wakeWord'], defaults.wakeWord),
    );
  }

  static bool _flag(Object? value, bool fallback) =>
      value is bool ? value : fallback;

  static double? _scale(Object? value) {
    if (value is! num || !value.isFinite) return null;
    return value
        .toDouble()
        .clamp(AppDefaults.minTextScale, AppDefaults.maxTextScale)
        .toDouble();
  }

  static T? _enumByName<T extends Enum>(Object? name, List<T> values) =>
      values.where((item) => item.name == name).firstOrNull;
}
