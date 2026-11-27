import 'package:equatable/equatable.dart';

import '../../../../core/audio/audio_format.dart';
import '../../../../core/errors/errors.dart';
import '../../../../core/feedback/feedback_cue.dart';

/// Something the outside world must do after a transition. The state machine
/// only describes it; the cubit does it.
sealed class VoiceEffect extends Equatable {
  const VoiceEffect();

  @override
  List<Object?> get props => const [];
}

/// Hand the microphone to the wake word spotter.
final class StartStandby extends VoiceEffect {
  const StartStandby();
}

/// Take the microphone back from the wake word spotter.
final class StopStandby extends VoiceEffect {
  const StopStandby();
}

final class PlayCue extends VoiceEffect {
  const PlayCue(this.cue);

  final FeedbackCue cue;

  @override
  List<Object?> get props => [cue];
}

final class BeginCapture extends VoiceEffect {
  const BeginCapture();
}

final class CancelCapture extends VoiceEffect {
  const CancelCapture();
}

final class ProcessClip extends VoiceEffect {
  const ProcessClip(this.clip);

  final AudioClip clip;

  @override
  List<Object?> get props => [clip];
}

final class CancelProcessing extends VoiceEffect {
  const CancelProcessing();
}

final class Speak extends VoiceEffect {
  const Speak(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

final class StopSpeech extends VoiceEffect {
  const StopSpeech();
}

/// Tell the error system. It announces the problem by voice.
final class ReportFailure extends VoiceEffect {
  const ReportFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

/// Wait until everything queued for speaking is finished.
final class AwaitSpeech extends VoiceEffect {
  const AwaitSpeech();
}
