import 'dart:typed_data';

import '../../../core/errors/exceptions/model_exception.dart';
import 'spotter_defaults.dart';
import 'spotter_model_paths.dart';

abstract interface class KeywordEngine {
  List<String> accept(Float32List samples);

  void dispose();
}

typedef KeywordEngineFactory = KeywordEngine Function(SpotterModelPaths paths);

KeywordEngine createEngineSafely(
  KeywordEngineFactory factory,
  SpotterModelPaths paths,
) {
  try {
    return factory(paths);
  } on ModelException {
    rethrow;
  } catch (error) {
    throw ModelException(
      message: SpotterErrors.engineMessage,
      code: SpotterErrors.engineCode,
      cause: error,
    );
  }
}
