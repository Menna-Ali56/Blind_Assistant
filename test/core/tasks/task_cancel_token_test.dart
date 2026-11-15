import 'package:baseer/core/tasks/tasks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a new token is not cancelled', () {
    final token = TaskCancelToken();
    expect(token.isCancelled, isFalse);
    expect(token.throwIfCancelled, returnsNormally);
  });

  test('cancel sets the flag and wakes listeners', () async {
    final token = TaskCancelToken();
    final woke = token.whenCancelled;
    token.cancel();
    await woke;
    expect(token.isCancelled, isTrue);
  });

  test('cancel twice is safe', () {
    final token = TaskCancelToken()..cancel();
    expect(token.cancel, returnsNormally);
  });

  test('throwIfCancelled throws after cancel', () {
    final token = TaskCancelToken()..cancel();
    expect(token.throwIfCancelled, throwsA(isA<TaskCancelledException>()));
  });
}
