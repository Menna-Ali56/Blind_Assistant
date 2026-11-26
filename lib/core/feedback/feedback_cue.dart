import '../output/output_priority.dart';

enum FeedbackCue {
  listening,
  done,
  error,
  warningInfo,
  warningUrgent,
  warningEmergency;

  static FeedbackCue? forPriority(OutputPriority priority) =>
      switch (priority) {
        OutputPriority.low => null,
        OutputPriority.normal => warningInfo,
        OutputPriority.high => warningUrgent,
        OutputPriority.critical => warningEmergency,
      };
}
