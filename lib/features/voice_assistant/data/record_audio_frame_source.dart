import 'dart:async';
import 'dart:typed_data';

import 'package:record/record.dart';

import '../../../core/errors/exceptions/microphone_exception.dart';
import 'audio_frame_source.dart';
import 'spotter_defaults.dart';

class RecordAudioFrameSource implements AudioFrameSource {
  RecordAudioFrameSource() : _recorder = AudioRecorder();

  static const _config = RecordConfig(
    encoder: AudioEncoder.pcm16bits,
    sampleRate: SpotterDefaults.sampleRate,
    numChannels: SpotterDefaults.channels,
  );

  final AudioRecorder _recorder;

  final StreamController<Uint8List> _frames =
      StreamController<Uint8List>.broadcast();

  StreamSubscription<Uint8List>? _subscription;

  Future<void> _pendingOperation = Future<void>.value();

  bool _isRecording = false;
  bool _isDisposed = false;

  @override
  Stream<Uint8List> get frames => _frames.stream;

  /// Serializes start, stop, and dispose operations.
  Future<void> _enqueue(Future<void> Function() operation) {
    final result = _pendingOperation.then((_) => operation());

    // Keep the queue usable even if the current operation fails.
    _pendingOperation = result.catchError((Object _) {});

    return result;
  }

  @override
  Future<void> start() => _enqueue(_startInternal);

  Future<void> _startInternal() async {
    if (_isDisposed) {
      throw const MicrophoneException(
        message: 'Cannot start a disposed audio source',
      );
    }

    if (_isRecording) return;

    try {
      final stream = await _recorder.startStream(_config);

      _isRecording = true;

      _subscription = stream.listen(
        (frame) {
          if (!_frames.isClosed) {
            _frames.add(frame);
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          if (!_frames.isClosed) {
            _frames.addError(error, stackTrace);
          }
        },
      );
    } catch (error) {
      try {
        await _stopInternal();
      } catch (_) {
        // Preserve the original start error.
      }

      if (error is MicrophoneException) rethrow;

      throw MicrophoneException(cause: error);
    }
  }

  @override
  Future<void> stop() => _enqueue(_stopInternal);

  Future<void> _stopInternal() async {
    Object? firstError;

    final subscription = _subscription;
    _subscription = null;

    try {
      await subscription?.cancel();
    } catch (error) {
      firstError = error;
    }

    if (_isRecording) {
      _isRecording = false;

      try {
        await _recorder.stop();
      } catch (error) {
        firstError ??= error;
      }
    }

    if (firstError != null) {
      throw MicrophoneException(cause: firstError);
    }
  }

  @override
  Future<void> dispose() => _enqueue(_disposeInternal);

  Future<void> _disposeInternal() async {
    if (_isDisposed) return;

    _isDisposed = true;

    Object? firstError;

    try {
      await _stopInternal();
    } catch (error) {
      firstError = error;
    }

    try {
      await _recorder.dispose();
    } catch (error) {
      firstError ??= error;
    }

    try {
      await _frames.close();
    } catch (error) {
      firstError ??= error;
    }

    if (firstError != null) {
      throw MicrophoneException(cause: firstError);
    }
  }
}
