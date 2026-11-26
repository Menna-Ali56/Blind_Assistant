import 'dart:async';
import 'dart:typed_data';

import '../../permissions/domain/repositories/permission_repository.dart';
import '../domain/entities/spotter_event.dart';
import '../domain/repositories/keyword_spotter.dart';
import 'audio_frame_source.dart';
import 'keyword_engine.dart';
import 'microphone_guard.dart';
import 'pcm16_converter.dart';
import 'spotter_defaults.dart';
import 'spotter_model_loader.dart';

class SherpaKeywordSpotter implements KeywordSpotter {
  SherpaKeywordSpotter({
    required this._loader,
    required this._source,
    required PermissionRepository permissions,
    required this._engineFactory,
    this.onError,
  }) : _guard = MicrophoneGuard(permissions);

  final SpotterModelLoader _loader;
  final AudioFrameSource _source;
  final MicrophoneGuard _guard;
  final KeywordEngineFactory _engineFactory;
  final void Function(Object error)? onError;
  final StreamController<SpotterEvent> _events = StreamController.broadcast();
  KeywordEngine? _engine;
  StreamSubscription<Uint8List>? _subscription;
  bool _starting = false;

  @override
  Stream<SpotterEvent> get events => _events.stream;

  @override
  Future<void> start() async {
    if (_engine != null || _starting) return;
    _starting = true;
    try {
      await _guard.require();
      _engine = createEngineSafely(_engineFactory, await _loader.load());
      _subscription = _source.frames.listen(_onFrame, onError: _fail);
      await _source.start();
    } catch (_) {
      await _release();
      rethrow;
    } finally {
      _starting = false;
    }
  }

  @override
  Future<void> stop() => _release();

  Future<void> dispose() async {
    await _release();
    await _events.close();
  }

  void _onFrame(Uint8List frame) {
    final engine = _engine;
    if (engine == null) return;
    try {
      for (final keyword in engine.accept(Pcm16Converter.toFloat(frame))) {
        _events.add(
          SpotterEvent(
            keyword: keyword,
            confidence: SpotterDefaults.reportedConfidence,
          ),
        );
      }
    } catch (error) {
      _fail(error);
    }
  }

  void _fail(Object error) {
    onError?.call(error);
    unawaited(_release());
  }

  Future<void> _release() async {
    final subscription = _subscription;
    final engine = _engine;
    _subscription = null;
    _engine = null;
    try {
      await subscription?.cancel();
      await _source.stop();
    } catch (error) {
      onError?.call(error);
    }
    engine?.dispose();
  }
}
