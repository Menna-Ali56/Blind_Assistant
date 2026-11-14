import 'package:baseer/core/errors/failures/retry_hint.dart';
import 'package:baseer/core/network/attempt_tracker.dart';
import 'package:baseer/core/tasks/task_id_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AttemptTracker tracker;

  setUp(() => tracker = AttemptTracker(UuidV4Generator()));

  test('same request keeps the id', () {
    final first = tracker.begin();

    expect(tracker.retry(RetryHint.sameRequest), first);
  });

  test('new capture makes a new id', () {
    final first = tracker.begin();

    expect(tracker.retry(RetryHint.newCapture), isNot(first));
  });

  test('same request retries stop at the limit', () {
    tracker.begin();
    while (tracker.canRetry(RetryHint.sameRequest)) {
      tracker.retry(RetryHint.sameRequest);
    }

    expect(tracker.canRetry(RetryHint.sameRequest), isFalse);
    expect(tracker.canRetry(RetryHint.newCapture), isTrue);
  });

  test('login and none are never retried', () {
    expect(tracker.canRetry(RetryHint.login), isFalse);
    expect(tracker.canRetry(RetryHint.none), isFalse);
  });
}
