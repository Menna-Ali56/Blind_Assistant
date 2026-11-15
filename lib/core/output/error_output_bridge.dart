import 'dart:async';

import '../errors/errors.dart';
import 'output_channel.dart';
import 'output_coordinator.dart';
import 'output_message.dart';
import 'output_priority.dart';

class ErrorOutputBridge {
  ErrorOutputBridge({
    required this._supervisor,
    required this._coordinator,
    required this._languageCode,
    this._messages = const ErrorMessageMapper(),
  });

  static const String ownerKeyPrefix = 'error:';

  final ErrorSupervisor _supervisor;
  final OutputCoordinator _coordinator;
  final String Function() _languageCode;
  final ErrorMessageMapper _messages;
  StreamSubscription<ErrorReport>? _subscription;

  void start() {
    _subscription ??= _supervisor.reports
        .where((report) => report.shouldAnnounce)
        .listen(_onReport);
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  void _onReport(ErrorReport report) {
    final languageCode = _languageCode();
    final presentation = ErrorPresentation.from(
      report.failure,
      languageCode: languageCode,
      messages: _messages,
    );
    if (presentation.isSilent) return;
    _coordinator.submit(
      OutputMessage(
        text: presentation.spoken,
        languageCode: languageCode,
        priority: _priorityOf(report.severity),
        haptic: _hapticOf(report.severity),
        key: '$ownerKeyPrefix${report.failure.code}',
      ),
    );
  }

  OutputPriority _priorityOf(ErrorSeverity severity) => switch (severity) {
    ErrorSeverity.info => OutputPriority.low,
    ErrorSeverity.warning => OutputPriority.normal,
    ErrorSeverity.error => OutputPriority.high,
    ErrorSeverity.critical => OutputPriority.critical,
  };

  OutputHaptic _hapticOf(ErrorSeverity severity) => switch (severity) {
    ErrorSeverity.info => OutputHaptic.none,
    ErrorSeverity.warning => OutputHaptic.light,
    ErrorSeverity.error || ErrorSeverity.critical => OutputHaptic.heavy,
  };
}
