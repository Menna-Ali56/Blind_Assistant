import 'dart:io';

import 'package:baseer/core/errors/errors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DateTime clock;
  late ErrorSupervisor supervisor;

  void advance(Duration by) => clock = clock.add(by);

  setUp(() {
    clock = DateTime(2026);
    supervisor = ErrorSupervisor(now: () => clock);
  });

  tearDown(() => supervisor.dispose());

  test('a cancel is silent and only informational', () {
    final report = supervisor.reportFailure(const CancelledFailure());

    expect(report.shouldAnnounce, isFalse);
    expect(report.severity, ErrorSeverity.info);
  });

  test('a network failure is announced as a warning', () {
    final report = supervisor.reportFailure(const NetworkFailure());

    expect(report.shouldAnnounce, isTrue);
    expect(report.severity, ErrorSeverity.warning);
  });

  test('the same failure inside the repeat window is not announced twice', () {
    supervisor.reportFailure(const NetworkFailure());
    advance(const Duration(seconds: 1));
    final second = supervisor.reportFailure(const NetworkFailure());

    expect(second.shouldAnnounce, isFalse);
    expect(second.occurrences, 2);
  });

  test('it is announced again once the window has passed', () {
    supervisor.reportFailure(const NetworkFailure());
    advance(const Duration(seconds: 4));
    final second = supervisor.reportFailure(const NetworkFailure());

    expect(second.shouldAnnounce, isTrue);
  });

  test('a failure that keeps repeating escalates and stops retrying', () {
    supervisor.reportFailure(const NetworkFailure());
    advance(const Duration(seconds: 1));
    supervisor.reportFailure(const NetworkFailure());
    advance(const Duration(seconds: 4));
    final third = supervisor.reportFailure(const NetworkFailure());

    expect(third.isRepeating, isTrue);
    expect(third.severity, ErrorSeverity.error);
    expect(third.canRetry, isFalse);
    expect(third.shouldAnnounce, isTrue);
  });

  test('the counter starts over after the escalation window', () {
    supervisor.reportFailure(const NetworkFailure());
    advance(const Duration(minutes: 2));
    final later = supervisor.reportFailure(const NetworkFailure());

    expect(later.occurrences, 1);
    expect(later.isRepeating, isFalse);
  });

  test('uncaught errors are critical', () {
    final report = supervisor.report(
      StateError('boom'),
      uncaught: true,
      log: false,
    );

    expect(report.failure, isA<UnknownFailure>());
    expect(report.severity, ErrorSeverity.critical);
  });

  test('raw exceptions are mapped to failures', () {
    final report = supervisor.report(const SocketException('x'), log: false);

    expect(report.failure, isA<NetworkFailure>());
  });

  test('watch reports failures only and returns the result unchanged', () async {
    final seen = <ErrorReport>[];
    supervisor.reports.listen(seen.add);

    final ok = await supervisor.watch(
      Future.value(const ResultSuccess<int>(1)),
    );
    final bad = await supervisor.watch(
      Future.value(const ResultFailure<int>(NetworkFailure())),
    );
    await pumpEventQueue();

    expect(ok.isSuccess, isTrue);
    expect(bad.isFailure, isTrue);
    expect(seen, hasLength(1));
  });
}
