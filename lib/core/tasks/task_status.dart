enum TaskStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled;

  bool get isTerminal => const {completed, failed, cancelled}.contains(this);
}
