import '../constants/app_defaults.dart';
import '../errors/failures/retry_hint.dart';
import '../tasks/task_id_generator.dart';

class AttemptTracker {
  AttemptTracker(
    this._ids, {
    this.maxSameRequestRetries = AppDefaults.maxSameRequestRetries,
  });

  final TaskIdGenerator _ids;
  final int maxSameRequestRetries;
  String _id = '';
  int _retries = 0;

  String get id => _id;

  String begin() {
    _retries = 0;
    return _id = _ids.next();
  }

  bool canRetry(RetryHint hint) => switch (hint) {
    RetryHint.sameRequest => _retries < maxSameRequestRetries,
    RetryHint.newCapture => true,
    RetryHint.login || RetryHint.none => false,
  };

  String retry(RetryHint hint) {
    if (hint != RetryHint.sameRequest) return begin();
    _retries++;
    return _id;
  }
}
