import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../../core/errors/failures/failure.dart';
import '../../../core/errors/handlers/error_handler.dart';
import '../domain/repositories/camera_service.dart';

class CameraLifecycleObserver with WidgetsBindingObserver {
  CameraLifecycleObserver({
    required this._service,
    required this.onFailure,
    this._errorHandler = const ErrorHandler(),
  });

  final CameraService _service;
  final ErrorHandler _errorHandler;
  final void Function(Failure failure) onFailure;

  void attach() => WidgetsBinding.instance.addObserver(this);

  void detach() => WidgetsBinding.instance.removeObserver(this);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final action = switch (state) {
      AppLifecycleState.resumed => _service.resume,
      AppLifecycleState.detached => null,
      _ => _service.pause,
    };
    if (action != null) unawaited(_run(action));
  }

  Future<void> _run(Future<void> Function() action) async {
    final outcome = await _errorHandler.guard(
      action,
      context: 'camera_lifecycle',
    );
    outcome.fold(onSuccess: (_) {}, onFailure: onFailure);
  }
}
