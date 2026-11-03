import 'dart:developer' as developer;

class ErrorLogger {
  const ErrorLogger();

  /// Never pass OCR text, transcripts, images, tokens, or personal content here.
  void log(
    Object error,
    StackTrace stackTrace, {
    String? context,
    String? code,
  }) {
    developer.log(
      'Handled error: ${error.runtimeType}; '
      'context: ${context ?? 'unknown'}; code: ${code ?? 'none'}',
      name: 'Baseer.Error',
      error: error.runtimeType.toString(),
      stackTrace: stackTrace,
      level: 900,
    );
  }
}
