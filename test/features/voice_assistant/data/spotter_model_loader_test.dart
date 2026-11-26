import 'package:baseer/core/errors/exceptions/model_exception.dart';
import 'package:baseer/features/voice_assistant/data/spotter_defaults.dart';
import 'package:baseer/features/voice_assistant/data/spotter_model_config.dart';
import 'package:baseer/features/voice_assistant/data/spotter_model_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import 'spotter_test_support.dart';

void main() {
  const content = [1, 2, 3];
  late SpotterModelConfig config;
  late Map<String, List<int>> files;

  setUp(() {
    final hash = hashOf(content);
    config = SpotterModelConfig(
      directory: 'dir',
      files: {
        for (final role in SpotterFileRole.values)
          role: SpotterModelFile(name: '${role.name}.bin', sha256: hash),
      },
    );
    files = {
      for (final file in config.files.values) config.pathOf(file): content,
    };
  });

  SpotterModelLoader loader() =>
      SpotterModelLoader(config, FakeModelFileSource(files));

  test('returns a path for every role when hashes match', () async {
    final paths = await loader().load();
    final file = config.files[SpotterFileRole.tokens]!;
    expect(paths[SpotterFileRole.tokens], config.pathOf(file));
  });

  test('accepts an upper case expected hash', () async {
    final file = config.files[SpotterFileRole.joiner]!;
    final upper = SpotterModelFile(
      name: file.name,
      sha256: file.sha256.toUpperCase(),
    );
    config = SpotterModelConfig(
      directory: config.directory,
      files: {...config.files, SpotterFileRole.joiner: upper},
    );
    await loader().load();
  });

  test('missing file throws a model exception', () async {
    files.remove(files.keys.first);
    expect(
      loader().load(),
      throwsA(
        isA<ModelException>().having(
          (e) => e.code,
          'code',
          SpotterErrors.missingCode,
        ),
      ),
    );
  });

  test('wrong hash throws a model exception', () async {
    files[files.keys.first] = [9, 9];
    expect(
      loader().load(),
      throwsA(
        isA<ModelException>().having(
          (e) => e.code,
          'code',
          SpotterErrors.checksumCode,
        ),
      ),
    );
  });

  test('placeholder config never passes the check', () {
    final placeholder = SpotterModelConfig.placeholder;
    final all = {
      for (final file in placeholder.files.values)
        placeholder.pathOf(file): content,
    };
    expect(
      SpotterModelLoader(placeholder, FakeModelFileSource(all)).load(),
      throwsA(isA<ModelException>()),
    );
  });
}
