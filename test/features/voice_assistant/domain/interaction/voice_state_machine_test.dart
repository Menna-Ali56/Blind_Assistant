import 'dart:typed_data';

import 'package:baseer/core/audio/audio_format.dart';
import 'package:baseer/core/errors/failures/cancelled_failure.dart';
import 'package:baseer/core/errors/failures/failure.dart';
import 'package:baseer/core/errors/failures/microphone_failure.dart';
import 'package:baseer/core/errors/failures/permission_failure.dart';
import 'package:baseer/core/errors/failures/speech_failure.dart';
import 'package:baseer/core/errors/failures/timeout_failure.dart';
import 'package:baseer/core/feedback/feedback_cue.dart';
import 'package:baseer/features/voice_assistant/domain/entities/command_outcome.dart';
import 'package:baseer/features/voice_assistant/domain/interaction/voice_effect.dart';
import 'package:baseer/features/voice_assistant/domain/interaction/voice_event.dart';
import 'package:baseer/features/voice_assistant/domain/interaction/voice_interaction_state.dart';
import 'package:baseer/features/voice_assistant/domain/interaction/voice_phase.dart';
import 'package:baseer/features/voice_assistant/domain/interaction/voice_state_machine.dart';
import 'package:baseer/features/voice_assistant/domain/interaction/voice_transition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final clip = AudioClip(Uint8List.fromList([1, 2, 3, 4]));

  VoiceInteractionState state(
    VoicePhase phase, {
    bool standby = false,
    Failure? failure,
  }) => VoiceInteractionState(phase: phase, standby: standby, failure: failure);

  VoiceTransition step(VoiceInteractionState s, VoiceEvent e) =>
      VoiceStateMachine.next(s, e);

  group('standby', () {
    test('starting it while idle starts the spotter', () {
      final t = step(state(VoicePhase.idle), const StandbyRequested());
      expect(t.state, state(VoicePhase.idle, standby: true));
      expect(t.effects, const [StartStandby()]);
    });

    test('starting it while busy only remembers it', () {
      final t = step(state(VoicePhase.speaking), const StandbyRequested());
      expect(t.state, state(VoicePhase.speaking, standby: true));
      expect(t.effects, isEmpty);
    });

    test('stopping it while idle stops the spotter', () {
      final t = step(
        state(VoicePhase.idle, standby: true),
        const StandbyReleased(),
      );
      expect(t.state, state(VoicePhase.idle));
      expect(t.effects, const [StopStandby()]);
    });
  });

  group('wake word', () {
    test('takes the microphone from the spotter, then listens', () {
      final t = step(state(VoicePhase.idle, standby: true), const WakeHeard());
      expect(t.state, state(VoicePhase.listening, standby: true));
      expect(t.effects, const [
        StopStandby(),
        PlayCue(FeedbackCue.listening),
        BeginCapture(),
      ]);
    });

    test('is ignored when not idle', () {
      for (final phase in [
        VoicePhase.listening,
        VoicePhase.processing,
        VoicePhase.speaking,
      ]) {
        final s = state(phase, standby: true);
        final t = step(s, const WakeHeard());
        expect(t.state, s);
        expect(t.effects, isEmpty);
      }
    });

    test('is ignored when standby is off', () {
      final t = step(state(VoicePhase.idle), const WakeHeard());
      expect(t.state.phase, VoicePhase.idle);
      expect(t.effects, isEmpty);
    });
  });

  group('tap', () {
    test('while idle without standby listens without touching the spotter', () {
      final t = step(state(VoicePhase.idle), const TapPressed());
      expect(t.state.phase, VoicePhase.listening);
      expect(t.effects, const [PlayCue(FeedbackCue.listening), BeginCapture()]);
    });

    test('while idle with standby stops the spotter first', () {
      final t = step(state(VoicePhase.idle, standby: true), const TapPressed());
      expect(t.effects.first, const StopStandby());
    });

    test('while listening cancels and resumes standby', () {
      final t = step(
        state(VoicePhase.listening, standby: true),
        const TapPressed(),
      );
      expect(t.state, state(VoicePhase.idle, standby: true));
      expect(t.effects, const [CancelCapture(), StartStandby()]);
    });

    test('while processing cancels', () {
      final t = step(state(VoicePhase.processing), const TapPressed());
      expect(t.state.phase, VoicePhase.idle);
      expect(t.effects, const [CancelProcessing()]);
    });

    test('while speaking cuts the answer off and listens', () {
      final t = step(
        state(VoicePhase.speaking, standby: true),
        const TapPressed(),
      );
      expect(t.state.phase, VoicePhase.listening);
      // The spotter is not running while speaking, so it is not stopped.
      expect(t.effects, const [
        StopSpeech(),
        PlayCue(FeedbackCue.listening),
        BeginCapture(),
      ]);
    });
  });

  group('capture', () {
    test('a recording goes to processing', () {
      final t = step(state(VoicePhase.listening), CaptureCompleted(clip));
      expect(t.state.phase, VoicePhase.processing);
      expect(t.effects, [ProcessClip(clip), const PlayCue(FeedbackCue.done)]);
    });

    test('an empty recording counts as no input', () {
      final t = step(
        state(VoicePhase.listening),
        CaptureCompleted(AudioClip(Uint8List(0))),
      );
      expect(t.state.phase, VoicePhase.speaking);
      expect(t.state.failure, const SpeechFailure.noInput());
    });

    test('a late recording is ignored', () {
      final s = state(VoicePhase.idle);
      expect(step(s, CaptureCompleted(clip)).state, s);
    });
  });

  group('failures', () {
    test('are reported, then the user waits for the announcement', () {
      const failure = MicrophoneFailure();
      final t = step(
        state(VoicePhase.listening, standby: true),
        const CaptureFailed(failure),
      );
      expect(
        t.state,
        state(VoicePhase.speaking, standby: true, failure: failure),
      );
      expect(t.effects, const [ReportFailure(failure), AwaitSpeech()]);
    });

    test('a missing permission turns standby off', () {
      const failure = PermissionFailure(permission: 'microphone');
      final t = step(
        state(VoicePhase.listening, standby: true),
        const CaptureFailed(failure),
      );
      expect(t.state.standby, isFalse);
    });

    test('a cancelled turn is silent', () {
      final t = step(
        state(VoicePhase.listening, standby: true),
        const CaptureFailed(CancelledFailure()),
      );
      expect(t.state, state(VoicePhase.idle, standby: true));
      expect(t.effects, const [StartStandby()]);
    });

    test('a processing failure is announced', () {
      final t = step(
        state(VoicePhase.processing),
        const ProcessingFailed(TimeoutFailure()),
      );
      expect(t.state.phase, VoicePhase.speaking);
      expect(t.effects.first, const ReportFailure(TimeoutFailure()));
    });
  });

  group('reply', () {
    test('is spoken', () {
      final t = step(
        state(VoicePhase.processing),
        const ReplyReady(CommandOutcome(spoken: ' Hello ')),
      );
      expect(t.state.phase, VoicePhase.speaking);
      expect(t.effects, const [Speak('Hello')]);
    });

    test('with nothing to say goes straight back to idle', () {
      final t = step(
        state(VoicePhase.processing, standby: true),
        const ReplyReady(CommandOutcome()),
      );
      expect(t.state, state(VoicePhase.idle, standby: true));
      expect(t.effects, const [StartStandby()]);
    });

    test('finishing speaking returns to standby', () {
      final t = step(
        state(VoicePhase.speaking, standby: true),
        const SpeechEnded(),
      );
      expect(t.state, state(VoicePhase.idle, standby: true));
      expect(t.effects, const [StartStandby()]);
    });

    test('a late "speech ended" is ignored', () {
      final s = state(VoicePhase.listening);
      expect(step(s, const SpeechEnded()).state, s);
    });
  });

  group('cancel and interruptions', () {
    test('cancel stops whatever is running', () {
      expect(
        step(state(VoicePhase.listening), const CancelRequested()).effects,
        const [CancelCapture()],
      );
      expect(
        step(state(VoicePhase.processing), const CancelRequested()).effects,
        const [CancelProcessing()],
      );
      expect(
        step(state(VoicePhase.speaking), const CancelRequested()).effects,
        const [StopSpeech()],
      );
      expect(
        step(state(VoicePhase.idle), const CancelRequested()).effects,
        isEmpty,
      );
    });

    test('an interruption ends a recording', () {
      final t = step(
        state(VoicePhase.listening, standby: true),
        const Interrupted(),
      );
      expect(t.state.phase, VoicePhase.idle);
      expect(t.effects, const [CancelCapture(), StartStandby()]);
    });

    test('an interruption does not touch other phases', () {
      for (final phase in [
        VoicePhase.idle,
        VoicePhase.processing,
        VoicePhase.speaking,
      ]) {
        final s = state(phase);
        expect(step(s, const Interrupted()).state, s);
      }
    });
  });
}
