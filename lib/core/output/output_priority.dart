enum OutputPriority {
  low,
  normal,
  high,
  critical;

  bool interrupts(OutputPriority other) => index > other.index;
}
