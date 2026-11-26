import 'cue_output.dart';
import 'feedback_cue.dart';

class NoCueOutput implements CueOutput {
  const NoCueOutput();

  @override
  Future<void> play(FeedbackCue cue) async {}

  @override
  Future<void> cancel() async {}
}
