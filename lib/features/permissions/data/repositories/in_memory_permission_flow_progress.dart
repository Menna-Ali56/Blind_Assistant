import '../../domain/repositories/permission_flow_progress.dart';

class InMemoryPermissionFlowProgress implements PermissionFlowProgress {
  bool _completed = false;

  @override
  bool get isCompleted => _completed;

  @override
  Future<void> load() async {}

  @override
  void markCompleted() => _completed = true;
}
