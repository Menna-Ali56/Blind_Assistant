enum ErrorSeverity {
  info,
  warning,
  error,
  critical;

  int get priority => index;

  ErrorSeverity get escalated =>
      this == critical ? critical : values[index + 1];
}
