import 'dart:developer' as developer;

/// Signature for forwarding errors to a crash-reporting service.
typedef ErrorReporter = void Function(
    Object error,
    StackTrace stackTrace,
    String? context,
    String? code,
    );

class ErrorLogger {
  const ErrorLogger();

  /// Set once at startup to forward errors to Crashlytics / Sentry:
  /// `ErrorLogger.reporter = (e, st, ctx, code) => ...;`
  /// Send only the error type, context and code. Never send user content.
  static ErrorReporter? reporter;

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

    try {
      reporter?.call(error, stackTrace, context, code);
    } catch (_) {
      // A broken reporter must never crash the app.
    }
  }
}