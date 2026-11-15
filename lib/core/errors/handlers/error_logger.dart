import 'dart:developer' as developer;

typedef ErrorReporter =
    void Function(
      Object error,
      StackTrace stackTrace,
      String? context,
      String? code,
    );

class ErrorLogger {
  const ErrorLogger();

  // set once to send errors out
  static ErrorReporter? reporter;

  // never send user data or tokens here
  void log(
    Object error,
    StackTrace stackTrace, {
    String? context,
    String? code,
    Map<String, Object?> fields = const {},
  }) {
    final extra = fields.isEmpty ? '' : '; fields: $fields';
    developer.log(
      'Handled error: ${error.runtimeType}; '
      'context: ${context ?? 'unknown'}; code: ${code ?? 'none'}$extra',
      name: 'Baseer.Error',
      error: error.runtimeType.toString(),
      stackTrace: stackTrace,
      level: 900,
    );

    try {
      reporter?.call(error, stackTrace, context, code);
    } catch (_) {
      return;
    }
  }
}
