import 'package:flutter/foundation.dart';

import 'error_logger.dart';

class GlobalErrorHandler {
  GlobalErrorHandler({
    this._logger = const ErrorLogger(),
  });

  final ErrorLogger _logger;
  bool _installed = false;

  void install() {
    if (_installed) return;
    _installed = true;

    final previousFlutterHandler = FlutterError.onError;

    FlutterError.onError = (details) {
      _logger.log(
        details.exception,
        details.stack ?? StackTrace.current,
        context: 'flutter_framework',
      );

      previousFlutterHandler?.call(details);
    };

    final previousPlatformHandler = PlatformDispatcher.instance.onError;

    PlatformDispatcher.instance.onError = (error, stack) {
      _logger.log(
        error,
        stack,
        context: 'platform_dispatcher',
      );

      return previousPlatformHandler?.call(error, stack) ?? false;
    };
  }
}