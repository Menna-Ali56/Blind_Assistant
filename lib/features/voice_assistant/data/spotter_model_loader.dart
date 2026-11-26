import 'package:crypto/crypto.dart';

import '../../../core/errors/exceptions/model_exception.dart';
import 'model_file_source.dart';
import 'spotter_defaults.dart';
import 'spotter_model_config.dart';
import 'spotter_model_paths.dart';

class SpotterModelLoader {
  const SpotterModelLoader(this._config, this._files);

  final SpotterModelConfig _config;
  final ModelFileSource _files;

  Future<SpotterModelPaths> load() async {
    final paths = <SpotterFileRole, String>{};
    for (final entry in _config.files.entries) {
      final path = _config.pathOf(entry.value);
      await _verify(path, entry.value.sha256);
      paths[entry.key] = path;
    }
    return SpotterModelPaths(paths);
  }

  Future<void> _verify(String path, String expected) async {
    if (!await _files.exists(path)) {
      throw const ModelException(
        message: SpotterErrors.missingMessage,
        code: SpotterErrors.missingCode,
      );
    }
    final actual = (await sha256.bind(_files.openRead(path)).first).toString();
    if (actual.toLowerCase() != expected.toLowerCase()) {
      throw const ModelException(
        message: SpotterErrors.checksumMessage,
        code: SpotterErrors.checksumCode,
      );
    }
  }
}
