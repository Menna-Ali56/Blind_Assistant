import '../../../../core/audio/audio_format.dart';
import '../../../../core/errors/errors.dart';
import '../../../../core/feedback/feedback_cue.dart';
import '../entities/command_outcome.dart';
import 'voice_effect.dart';
import 'voice_event.dart';
import 'voice_interaction_state.dart';
import 'voice_phase.dart';
import 'voice_transition.dart';

abstract final class VoiceStateMachine {
  static VoiceTransition next(VoiceInteractionState state, VoiceEvent event) =>
      switch (event) {
        StandbyRequested() => _standbyRequested(state),
        StandbyReleased() => _standbyReleased(state),
        WakeHeard() => _wakeHeard(state),
        TapPressed() => _tapPressed(state),
        CancelRequested() => _cancelRequested(state),
        Interrupted() => _interrupted(state),
        CaptureCompleted(:final clip) => _captureCompleted(state, clip),
        CaptureFailed(:final failure) => _failed(
          state,
          failure,
          from: VoicePhase.listening,
        ),
        ReplyReady(:final outcome) => _replyReady(state, outcome),
        ProcessingFailed(:final failure) => _failed(
          state,
          failure,
          from: VoicePhase.processing,
        ),
        SpeechEnded() => _speechEnded(state),
      };

  static VoiceTransition _standbyRequested(VoiceInteractionState state) {
    if (state.standby) return VoiceTransition(state);
    return VoiceTransition(state.withStandby(true), [
      if (state.isIdle) const StartStandby(),
    ]);
  }

  static VoiceTransition _standbyReleased(VoiceInteractionState state) {
    if (!state.standby) return VoiceTransition(state);
    return VoiceTransition(state.withStandby(false), [
      if (state.isIdle) const StopStandby(),
    ]);
  }

  static VoiceTransition _wakeHeard(VoiceInteractionState state) {
    if (!state.isIdle || !state.standby) return VoiceTransition(state);
    return _listen(state, releaseStandby: true);
  }

  static VoiceTransition _tapPressed(VoiceInteractionState state) =>
      switch (state.phase) {
        VoicePhase.idle => _listen(state, releaseStandby: state.standby),
        VoicePhase.listening => _idle(state, [const CancelCapture()]),
        VoicePhase.processing => _idle(state, [const CancelProcessing()]),
        // Tapping over the answer cuts it off and lets the user speak.
        VoicePhase.speaking => _listen(
          state,
          releaseStandby: false,
          before: [const StopSpeech()],
        ),
      };

  static VoiceTransition _cancelRequested(VoiceInteractionState state) =>
      switch (state.phase) {
        VoicePhase.idle => VoiceTransition(state),
        VoicePhase.listening => _idle(state, [const CancelCapture()]),
        VoicePhase.processing => _idle(state, [const CancelProcessing()]),
        VoicePhase.speaking => _idle(state, [const StopSpeech()]),
      };

  /// The audio went away. Speaking stops by itself (the output queue listens
  /// to the same signal) and processing does not need audio.
  static VoiceTransition _interrupted(VoiceInteractionState state) =>
      state.phase == VoicePhase.listening
      ? _idle(state, [const CancelCapture()])
      : VoiceTransition(state);

  static VoiceTransition _captureCompleted(
    VoiceInteractionState state,
    AudioClip clip,
  ) {
    if (state.phase != VoicePhase.listening) return VoiceTransition(state);
    if (clip.isEmpty) {
      return _failed(
        state,
        const SpeechFailure.noInput(),
        from: VoicePhase.listening,
      );
    }
    return VoiceTransition(state.moveTo(VoicePhase.processing), [
      ProcessClip(clip),
      const PlayCue(FeedbackCue.done),
    ]);
  }

  static VoiceTransition _replyReady(
    VoiceInteractionState state,
    CommandOutcome outcome,
  ) {
    if (state.phase != VoicePhase.processing) return VoiceTransition(state);
    final text = outcome.spoken?.trim();
    if (text == null || text.isEmpty) return _idle(state);
    return VoiceTransition(state.moveTo(VoicePhase.speaking), [Speak(text)]);
  }

  static VoiceTransition _speechEnded(VoiceInteractionState state) =>
      state.phase == VoicePhase.speaking
      ? _idle(state)
      : VoiceTransition(state);

  /// A turn failed while in [from]. The user hears it, then we are idle again.
  static VoiceTransition _failed(
    VoiceInteractionState state,
    Failure failure, {
    required VoicePhase from,
  }) {
    if (state.phase != from) return VoiceTransition(state);
    // Cancelling is the user's choice, not an error to announce.
    if (failure is CancelledFailure) return _idle(state);
    // Waiting for the wake word cannot work without the permission, and
    // trying again would just repeat the error.
    final standby = failure is PermissionFailure ? false : state.standby;
    final speaking = VoiceInteractionState(
      phase: VoicePhase.speaking,
      standby: standby,
      failure: failure,
    );
    return VoiceTransition(speaking, [
      ReportFailure(failure),
      const AwaitSpeech(),
    ]);
  }

  static VoiceTransition _listen(
    VoiceInteractionState state, {
    required bool releaseStandby,
    List<VoiceEffect> before = const [],
  }) => VoiceTransition(state.moveTo(VoicePhase.listening), [
    ...before,
    if (releaseStandby) const StopStandby(),
    const PlayCue(FeedbackCue.listening),
    const BeginCapture(),
  ]);

  static VoiceTransition _idle(
    VoiceInteractionState state, [
    List<VoiceEffect> before = const [],
  ]) => VoiceTransition(state.moveTo(VoicePhase.idle), [
    ...before,
    if (state.standby) const StartStandby(),
  ]);
}
