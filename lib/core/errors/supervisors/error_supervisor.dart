import 'dart:async';

import '../../constants/app_defaults.dart';
import '../failures/failure.dart';
import '../handlers/error_handler.dart';
import '../result/result.dart';
import 'error_policy.dart';
import 'error_report.dart';

class ErrorSupervisor {
  ErrorSupervisor({
    ErrorHandler errorHandler = const ErrorHandler(),
    this._policy = const ErrorPolicy(),
    DateTime Function()? now,
    this.repeatWindow = AppDefaults.errorRepeatWindow,
    this.escalateAfter = defaultEscalateAfter,
    this.escalationWindow = defaultEscalationWindow,
  }) : _errors = errorHandler,
       _now = now ?? DateTime.now;

  static const int defaultEscalateAfter = 3;
  static const Duration defaultEscalationWindow = Duration(seconds: 30);
  static const String unknownSource = 'unknown';
  static const String taskSource = 'task';

  final ErrorHandler _errors;
  final ErrorPolicy _policy;
  final DateTime Function() _now;

  final Duration repeatWindow;

  final int escalateAfter;
  final Duration escalationWindow;

  final StreamController<ErrorReport> _controller =
      StreamController<ErrorReport>.broadcast();
  final Map<Failure, _Seen> _seen = {};
  ErrorReport? _last;

  Stream<ErrorReport> get reports => _controller.stream;

  ErrorReport? get lastReport => _last;

  ErrorReport report(
    Object error, {
    StackTrace? stackTrace,
    String source = unknownSource,
    bool uncaught = false,
    bool log = true,
  }) {
    final failure = _toFailure(error, stackTrace, source, log);
    return reportFailure(failure, source: source, uncaught: uncaught);
  }

  ErrorReport reportFailure(
    Failure failure, {
    String source = unknownSource,
    bool uncaught = false,
  }) {
    final time = _now();
    final seen = _track(failure, time);
    final isRepeating = seen.count >= escalateAfter;
    final announce =
        _policy.shouldAnnounce(failure) &&
        !seen.announcedWithin(time, repeatWindow);
    if (announce) seen.lastAnnounced = time;

    var severity = _policy.severityOf(failure, uncaught: uncaught);
    if (isRepeating) severity = severity.escalated;

    final report = ErrorReport(
      failure: failure,
      severity: severity,
      source: source,
      at: time,
      occurrences: seen.count,
      shouldAnnounce: announce,
      isRepeating: isRepeating,
    );
    _last = report;
    if (!_controller.isClosed) _controller.add(report);
    return report;
  }

  Future<Result<T>> watch<T>(
    Future<Result<T>> result, {
    String source = taskSource,
  }) async {
    final outcome = await result;
    outcome.fold<void>(
      onSuccess: (_) {},
      onFailure: (failure) {
        reportFailure(failure, source: source);
      },
    );
    return outcome;
  }

  Future<void> dispose() {
    _seen.clear();
    return _controller.close();
  }

  Failure _toFailure(
    Object error,
    StackTrace? stackTrace,
    String source,
    bool log,
  ) {
    if (error is Failure) return error;
    if (!log) return _errors.mapper.map(error);
    return _errors.handle(
      error,
      stackTrace ?? StackTrace.current,
      context: source,
    );
  }

  _Seen _track(Failure failure, DateTime time) {
    final seen = _seen.putIfAbsent(failure, () => _Seen(time));
    if (time.difference(seen.windowStart) > escalationWindow) seen.reset(time);
    seen.count++;
    return seen;
  }
}

class _Seen {
  _Seen(this.windowStart);

  DateTime windowStart;
  int count = 0;
  DateTime? lastAnnounced;

  void reset(DateTime time) {
    windowStart = time;
    count = 0;
    lastAnnounced = null;
  }

  bool announcedWithin(DateTime time, Duration window) {
    final last = lastAnnounced;
    return last != null && time.difference(last) < window;
  }
}
