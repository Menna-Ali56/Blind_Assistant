import 'package:flutter/services.dart';

import '../../../../core/output/output.dart';
import '../data_sources/flutter_tts_data_source.dart';

class TtsSpeechChannel implements SpeechChannel {
  const TtsSpeechChannel(this._dataSource);

  final FlutterTtsDataSource _dataSource;

  @override
  Future<void> speak(
    String text, {
    required String languageCode,
    required OutputPriority priority,
  }) => _dataSource.speak(text, languageCode: languageCode);

  @override
  Future<void> stop() => _dataSource.stop();

  @override
  Future<void> haptic(OutputHaptic kind) => switch (kind) {
    OutputHaptic.none => Future<void>.value(),
    OutputHaptic.light => HapticFeedback.lightImpact(),
    OutputHaptic.heavy => HapticFeedback.heavyImpact(),
  };
}
