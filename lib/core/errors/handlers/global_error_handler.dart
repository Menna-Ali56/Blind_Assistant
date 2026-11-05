import 'package:flutter/foundation.dart';

import 'error_logger.dart';

class GlobalErrorHandler {
  GlobalErrorHandler({this._logger = const ErrorLogger(), this.onUnhandled});

  final ErrorLogger _logger;

  /// Optional hook called after an uncaught error is logged
  /// (e.g. to announce a generic failure to the user).
  final void Function(Object error, StackTrace stack)? onUnhandled;

  bool _installed = false;

  void install() {
    if (_installed) return;
    _installed = true;

    final previousFlutterHandler = FlutterError.onError;

    FlutterError.onError = (details) {
      final stack = details.stack ?? StackTrace.current;

      _logger.log(details.exception, stack, context: 'flutter_framework');
      _notify(details.exception, stack);

      previousFlutterHandler?.call(details);
    };

    final previousPlatformHandler = PlatformDispatcher.instance.onError;

    PlatformDispatcher.instance.onError = (error, stack) {
      _logger.log(error, stack, context: 'platform_dispatcher');
      _notify(error, stack);

      return previousPlatformHandler?.call(error, stack) ?? false;
    };
  }

  void _notify(Object error, StackTrace stack) {
    try {
      onUnhandled?.call(error, stack);
    } catch (_) {
      // The hook must never throw inside an error handler.
    }
  }
}
