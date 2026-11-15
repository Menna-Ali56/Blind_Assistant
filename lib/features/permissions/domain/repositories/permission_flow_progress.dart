abstract interface class PermissionFlowProgress {
  bool get isCompleted;

  Future<void> load();

  void markCompleted();
}
