import 'package:audio_session/audio_session.dart';

import 'audio_focus.dart';

class AudioSessionFocus implements AudioFocus {
  AudioSessionFocus();

  static const AudioSessionConfiguration _config = AudioSessionConfiguration(
    avAudioSessionCategory: AVAudioSessionCategory.playback,
    avAudioSessionMode: AVAudioSessionMode.spokenAudio,
    androidAudioAttributes: AndroidAudioAttributes(
      contentType: AndroidAudioContentType.speech,
      usage: AndroidAudioUsage.assistanceAccessibility,
    ),
    androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
  );

  bool _configured = false;

  @override
  Future<void> acquire() async {
    final session = await _ensureSession();
    if (session == null) return;
    if (!_configured) {
      await session.configure(_config);
      _configured = true;
    }
    await session.setActive(true);
  }

  @override
  Future<void> release() async {
    final session = await _ensureSession();
    if (session == null) return;
    await session.setActive(false);
  }

  @override
  Stream<void> get interruptions async* {
    final session = await _ensureSession();
    if (session == null) return;
    await for (final event in session.interruptionEventStream) {
      if (event.begin && event.type != AudioInterruptionType.duck) {
        yield null;
      }
    }
  }

  Future<AudioSession?> _ensureSession() async {
    try {
      return await AudioSession.instance;
    } catch (_) {
      return null;
    }
  }
}
