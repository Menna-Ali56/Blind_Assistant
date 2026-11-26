import 'dart:typed_data';

import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa;

import 'keyword_engine.dart';
import 'spotter_defaults.dart';
import 'spotter_model_config.dart';
import 'spotter_model_paths.dart';

class SherpaKeywordEngine implements KeywordEngine {
  SherpaKeywordEngine._(this._spotter) : _stream = _spotter.createStream();

  factory SherpaKeywordEngine.create(SpotterModelPaths paths) {
    sherpa.initBindings();
    final config = sherpa.KeywordSpotterConfig(
      model: sherpa.OnlineModelConfig(
        transducer: sherpa.OnlineTransducerModelConfig(
          encoder: paths[SpotterFileRole.encoder],
          decoder: paths[SpotterFileRole.decoder],
          joiner: paths[SpotterFileRole.joiner],
        ),
        tokens: paths[SpotterFileRole.tokens],
        numThreads: SpotterDefaults.threads,
      ),
      keywordsFile: paths[SpotterFileRole.keywords],
      keywordsScore: SpotterDefaults.keywordsScore,
      keywordsThreshold: SpotterDefaults.keywordsThreshold,
    );
    return SherpaKeywordEngine._(sherpa.KeywordSpotter(config));
  }

  final sherpa.KeywordSpotter _spotter;
  final sherpa.OnlineStream _stream;

  @override
  List<String> accept(Float32List samples) {
    _stream.acceptWaveform(
      samples: samples,
      sampleRate: SpotterDefaults.sampleRate,
    );
    final found = <String>[];
    while (_spotter.isReady(_stream)) {
      _spotter.decode(_stream);
      final keyword = _spotter.getResult(_stream).keyword;
      if (keyword.isEmpty) continue;
      found.add(keyword);
      _spotter.reset(_stream);
    }
    return found;
  }

  @override
  void dispose() {
    _stream.free();
    _spotter.free();
  }
}
