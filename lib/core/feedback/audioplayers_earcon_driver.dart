import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

import 'earcon_catalog.dart';
import 'earcon_driver.dart';

class AudioplayersEarconDriver implements EarconDriver {
  AudioplayersEarconDriver({this._player});

  static const String _mime = 'audio/wav';

  static final AudioContext _context = AudioContext(
    android: const AudioContextAndroid(
      audioFocus: AndroidAudioFocus.none,
      usageType: AndroidUsageType.assistanceAccessibility,
      contentType: AndroidContentType.sonification,
    ),
  );

  AudioPlayer? _player;
  Future<void>? _configured;

  AudioPlayer _ensurePlayer() => _player ??= AudioPlayer();

  @override
  Future<void> play(Uint8List wav, {required Duration length}) async {
    final player = _ensurePlayer();
    await (_configured ??= player.setAudioContext(_context));
    final done = player.onPlayerComplete.first.timeout(
      length + EarconCatalog.completionGrace,
      onTimeout: () {},
    );
    await player.stop();
    await player.play(BytesSource(wav, mimeType: _mime));
    await done;
  }

  @override
  Future<void> stop() async {
    final player = _player;
    if (player != null) await player.stop();
  }

  @override
  Future<void> dispose() async {
    final player = _player;
    _player = null;
    _configured = null;
    if (player != null) await player.dispose();
  }
}
