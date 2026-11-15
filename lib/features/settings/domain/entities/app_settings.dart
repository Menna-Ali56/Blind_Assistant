import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_defaults.dart';

enum VoiceRate { slow, normal, fast }

class AppSettings extends Equatable {
  const AppSettings({
    this.voiceRate = VoiceRate.normal,
    this.textScale = AppDefaults.textScale,
    this.highContrast = false,
    this.haptics = true,
    this.wakeWord = true,
  });

  final VoiceRate voiceRate;
  final double textScale;
  final bool highContrast;
  final bool haptics;
  final bool wakeWord;

  AppSettings copyWith({
    VoiceRate? voiceRate,
    double? textScale,
    bool? highContrast,
    bool? haptics,
    bool? wakeWord,
  }) {
    return AppSettings(
      voiceRate: voiceRate ?? this.voiceRate,
      textScale: textScale ?? this.textScale,
      highContrast: highContrast ?? this.highContrast,
      haptics: haptics ?? this.haptics,
      wakeWord: wakeWord ?? this.wakeWord,
    );
  }

  @override
  List<Object> get props => [
    voiceRate,
    textScale,
    highContrast,
    haptics,
    wakeWord,
  ];
}
