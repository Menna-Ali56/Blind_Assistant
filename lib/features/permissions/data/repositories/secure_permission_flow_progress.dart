import 'dart:async';

import '../../../../core/storage/secure_store.dart';
import '../../domain/repositories/permission_flow_progress.dart';

class SecurePermissionFlowProgress implements PermissionFlowProgress {
  SecurePermissionFlowProgress(this._store);

  static const String storageKey = 'permissions.flow.v1';
  static const String completedValue = 'done';

  final SecureStore _store;
  bool _completed = false;

  @override
  bool get isCompleted => _completed;

  @override
  Future<void> load() async {
    _completed = await _store.read(storageKey) == completedValue;
  }

  @override
  void markCompleted() {
    _completed = true;
    unawaited(_persist());
  }

  Future<void> _persist() async {
    try {
      await _store.write(storageKey, completedValue);
    } catch (_) {}
  }
}
