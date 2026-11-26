import 'dart:typed_data';

abstract interface class EarconDriver {
  Future<void> play(Uint8List wav, {required Duration length});

  Future<void> stop();

  Future<void> dispose();
}
