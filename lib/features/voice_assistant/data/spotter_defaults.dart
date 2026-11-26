abstract final class SpotterDefaults {
  static const int sampleRate = 16000;
  static const int channels = 1;
  static const int threads = 1;
  static const int pcmBytesPerSample = 2;
  static const double pcmScale = 32768;
  static const double keywordsScore = 1.5;
  static const double keywordsThreshold = 0.25;
  static const double reportedConfidence = 1;
  static const String placeholderDirectory = 'spotter_model';
  static const String placeholderHash =
      '0000000000000000000000000000000000000000000000000000000000000000';
}

abstract final class SpotterErrors {
  static const String missingCode = 'model_missing';
  static const String checksumCode = 'model_checksum';
  static const String engineCode = 'model_engine';
  static const String missingMessage = 'Spotter model file is missing';
  static const String checksumMessage = 'Spotter model file failed its check';
  static const String engineMessage = 'Spotter engine failed';
}
