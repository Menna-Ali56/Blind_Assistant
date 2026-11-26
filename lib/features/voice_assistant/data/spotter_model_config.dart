import 'dart:io';

import 'spotter_defaults.dart';

enum SpotterFileRole { encoder, decoder, joiner, tokens, keywords }

class SpotterModelFile {
  const SpotterModelFile({required this.name, required this.sha256});

  final String name;
  final String sha256;
}

class SpotterModelConfig {
  const SpotterModelConfig({required this.directory, required this.files});

  static const placeholder = SpotterModelConfig(
    directory: SpotterDefaults.placeholderDirectory,
    files: {
      SpotterFileRole.encoder: SpotterModelFile(
        name: 'encoder.onnx',
        sha256: SpotterDefaults.placeholderHash,
      ),
      SpotterFileRole.decoder: SpotterModelFile(
        name: 'decoder.onnx',
        sha256: SpotterDefaults.placeholderHash,
      ),
      SpotterFileRole.joiner: SpotterModelFile(
        name: 'joiner.onnx',
        sha256: SpotterDefaults.placeholderHash,
      ),
      SpotterFileRole.tokens: SpotterModelFile(
        name: 'tokens.txt',
        sha256: SpotterDefaults.placeholderHash,
      ),
      SpotterFileRole.keywords: SpotterModelFile(
        name: 'keywords.txt',
        sha256: SpotterDefaults.placeholderHash,
      ),
    },
  );

  final String directory;
  final Map<SpotterFileRole, SpotterModelFile> files;

  String pathOf(SpotterModelFile file) =>
      '$directory${Platform.pathSeparator}${file.name}';
}
