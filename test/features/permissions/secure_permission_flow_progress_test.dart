import 'package:baseer/core/storage/in_memory_secure_store.dart';
import 'package:baseer/features/permissions/data/repositories/secure_permission_flow_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('markCompleted persists and reloads on a fresh instance', () async {
    final store = InMemorySecureStore();
    final first = SecurePermissionFlowProgress(store);
    await first.load();
    expect(first.isCompleted, isFalse);

    first.markCompleted();
    await pumpEventQueue();

    final second = SecurePermissionFlowProgress(store);
    await second.load();
    expect(second.isCompleted, isTrue);
  });
}
