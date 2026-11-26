import 'feedback_cue.dart';

abstract interface class CueOutput {
  Future<void> play(FeedbackCue cue);

  Future<void> cancel();
}
