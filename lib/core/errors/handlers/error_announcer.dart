import 'package:flutter/services.dart';

import '../../constants/app_defaults.dart';
import '../failures/failure.dart';
import '../messages/error_message_mapper.dart';
import '../presentation/error_presentation.dart';

class ErrorAnnouncer {
  ErrorAnnouncer({
    required this.speak,
    this.mapper = const ErrorMessageMapper(),
    this.dedupeWindow = AppDefaults.errorRepeatWindow,
  });

  final Future<void> Function(String text) speak;
  final ErrorMessageMapper mapper;
  final Duration dedupeWindow;

  Failure? _lastFailure;
  DateTime? _lastAt;

  Future<ErrorPresentation> announce(
    Failure failure, {
    required String languageCode,
  }) async {
    final presentation = ErrorPresentation.from(
      failure,
      languageCode: languageCode,
      messages: mapper,
    );
    if (presentation.isSilent || _isRepeat(failure)) return presentation;
    _lastFailure = failure;
    _lastAt = DateTime.now();
    await _quietly(HapticFeedback.heavyImpact);
    await _quietly(() => speak(presentation.spoken));
    return presentation;
  }

  bool _isRepeat(Failure failure) {
    final lastAt = _lastAt;
    return failure == _lastFailure &&
        lastAt != null &&
        DateTime.now().difference(lastAt) < dedupeWindow;
  }

  // never throw in the error path
  Future<void> _quietly(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {}
  }
}
