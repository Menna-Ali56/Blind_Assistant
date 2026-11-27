import '../../../../core/audio/audio_format.dart';
import '../../../../core/errors/errors.dart';
import '../entities/command_outcome.dart';

/// Everything that can happen to the assistant.
sealed class VoiceEvent {
  const VoiceEvent();
}

/// The user (or the app) wants the wake word to be listened for.
final class StandbyRequested extends VoiceEvent {
  const StandbyRequested();
}

final class StandbyReleased extends VoiceEvent {
  const StandbyReleased();
}

final class WakeHeard extends VoiceEvent {
  const WakeHeard();
}

/// The big button. Starts listening, or stops whatever is going on.
final class TapPressed extends VoiceEvent {
  const TapPressed();
}

/// Stop everything and go back to idle (back button, app paused, ...).
final class CancelRequested extends VoiceEvent {
  const CancelRequested();
}

/// A call or another app took the audio.
final class Interrupted extends VoiceEvent {
  const Interrupted();
}

final class CaptureCompleted extends VoiceEvent {
  const CaptureCompleted(this.clip);

  final AudioClip clip;
}

final class CaptureFailed extends VoiceEvent {
  const CaptureFailed(this.failure);

  final Failure failure;
}

final class ReplyReady extends VoiceEvent {
  const ReplyReady(this.outcome);

  final CommandOutcome outcome;
}

final class ProcessingFailed extends VoiceEvent {
  const ProcessingFailed(this.failure);

  final Failure failure;
}

final class SpeechEnded extends VoiceEvent {
  const SpeechEnded();
}
