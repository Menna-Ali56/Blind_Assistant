import 'dart:typed_data';

import '../errors/errors.dart';
import 'audio_format.dart';

/// The microphone. Only one capture can run at a time.
abstract interface class AudioCapture {
  bool get isCapturing;

  /// Live PCM chunks while capturing. A broadcast stream.
  Stream<Uint8List> get chunks;

  /// Problems that happen after capturing started (another app took the
  /// microphone, a phone call, ...). Capturing has stopped when one arrives.
  Stream<Failure> get failures;

  /// Checks the permission, then opens the microphone.
  /// Fails with a `PermissionFailure` when access is missing.
  Future<Result<void>> start();

  /// Stops and returns everything captured since [start].
  Future<Result<AudioClip>> stop();

  /// Stops and throws the audio away.
  Future<void> cancel();

  Future<void> dispose();
}
