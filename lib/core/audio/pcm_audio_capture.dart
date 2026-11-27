import 'dart:async';
import 'dart:typed_data';

import '../errors/errors.dart';
import 'audio_capture.dart';
import 'audio_format.dart';
import 'microphone_access.dart';
import 'recorder_backend.dart';

class PcmAudioCapture implements AudioCapture {
  PcmAudioCapture({
    required this._backend,
    required this._access,
    ErrorHandler errorHandler = const ErrorHandler(),
    this.format = AudioFormat.speech,
    this.maxDuration = defaultMaxDuration,
    Stream<void> interruptions = const Stream<void>.empty(),
  }) : interruptions = interruptions.asBroadcastStream(),
       _errors = errorHandler;

  /// A safety net. The caller normally stops long before this.
  static const Duration defaultMaxDuration = Duration(seconds: 60);
  static const String _logContext = 'audio_capture';

  final RecorderBackend _backend;
  final MicrophoneAccess _access;
  final ErrorHandler _errors;
  final AudioFormat format;
  final Duration maxDuration;

  /// Something took the audio away (a call, another app).
  final Stream<void> interruptions;

  final BytesBuilder _buffer = BytesBuilder();
  final StreamController<Uint8List> _chunks =
      StreamController<Uint8List>.broadcast();
  final StreamController<Failure> _failures =
      StreamController<Failure>.broadcast();

  StreamSubscription<Uint8List>? _micSub;
  StreamSubscription<void>? _interruptSub;
  Timer? _limit;
  Future<Result<void>>? _starting;
  AudioClip? _endedClip;
  bool _capturing = false;

  @override
  bool get isCapturing => _capturing;

  @override
  Stream<Uint8List> get chunks => _chunks.stream;

  @override
  Stream<Failure> get failures => _failures.stream;

  @override
  Future<Result<void>> start() =>
      _starting ??= _begin().whenComplete(() => _starting = null);

  @override
  Future<Result<AudioClip>> stop() async {
    final ended = _endedClip;
    if (ended != null) {
      _endedClip = null;
      return ResultSuccess<AudioClip>(ended);
    }

    if (!_capturing) {
      return const ResultFailure<AudioClip>(MicrophoneFailure());
    }

    await _teardown();
    return ResultSuccess<AudioClip>(_takeClip());
  }

  @override
  Future<void> cancel() async {
    await _teardown();
    _buffer.clear();
    _endedClip = null;
  }

  @override
  Future<void> dispose() async {
    await cancel();
    await _chunks.close();
    await _failures.close();
  }

  Future<Result<void>> _begin() {
    if (_capturing) {
      return Future<Result<void>>.value(const ResultSuccess<void>(null));
    }

    return _errors.guard<void>(() async {
      final status = await _access.status();

      if (!status.isGranted) {
        throw PermissionException(
          permission: AppPermission.microphone,
          isPermanentlyDenied: status == MicrophoneStatus.blocked,
        );
      }

      _buffer.clear();
      _endedClip = null;

      final stream = await _backend.startStream(format);
      _capturing = true;

      _micSub = stream.listen(
        _onData,
        onError: _onStreamError,
        onDone: _onStreamDone,
      );

      _interruptSub = interruptions.listen(
        (_) => unawaited(_abort(const MicrophoneFailure())),
      );

      _limit = Timer(maxDuration, () => unawaited(_onLimit()));
    }, context: _logContext);
  }

  void _onData(Uint8List data) {
    _buffer.add(data);
    if (!_chunks.isClosed) _chunks.add(data);
  }

  void _onStreamError(Object error, StackTrace stackTrace) {
    unawaited(_abort(_errors.handle(error, stackTrace, context: _logContext)));
  }

  void _onStreamDone() {
    if (_capturing) {
      unawaited(_abort(const MicrophoneFailure()));
    }
  }

  Future<void> _abort(Failure failure) async {
    if (!_capturing) return;

    await _teardown();
    _buffer.clear();

    if (!_failures.isClosed) {
      _failures.add(failure);
    }
  }

  Future<void> _onLimit() async {
    if (!_capturing) return;

    await _teardown();
    _endedClip = _takeClip();
  }

  AudioClip _takeClip() => AudioClip(_buffer.takeBytes(), format: format);

  Future<void> _teardown() async {
    final wasCapturing = _capturing;
    _capturing = false;

    _limit?.cancel();
    _limit = null;

    final micSub = _micSub;
    _micSub = null;

    final interruptSub = _interruptSub;
    _interruptSub = null;

    await _errors.guard<void>(() async {
      await micSub?.cancel();
    }, context: _logContext);

    if (wasCapturing) {
      await _errors.guard<void>(_backend.stop, context: _logContext);
    }

    if (interruptSub != null) {
      unawaited(() async {
        await _errors.guard<void>(() async {
          await interruptSub.cancel();
        }, context: _logContext);
      }());
    }
  }
}
