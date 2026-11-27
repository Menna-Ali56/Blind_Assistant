import 'dart:async';
import 'dart:typed_data';

import 'package:baseer/core/audio/audio_capture.dart';
import 'package:baseer/core/audio/audio_format.dart';
import 'package:baseer/core/audio/utterance_recorder.dart';
import 'package:baseer/core/errors/failures/cancelled_failure.dart';
import 'package:baseer/core/errors/failures/failure.dart';
import 'package:baseer/core/errors/failures/speech_failure.dart';
import 'package:baseer/core/errors/result/result.dart';
import 'package:baseer/core/errors/supervisors/error_report.dart';
import 'package:baseer/core/errors/supervisors/error_supervisor.dart';
import 'package:baseer/core/feedback/cue_output.dart';
import 'package:baseer/core/feedback/feedback_cue.dart';
import 'package:baseer/core/tasks/task_cancel_token.dart';
import 'package:baseer/core/tasks/task_controller.dart';
import 'package:baseer/features/voice_assistant/domain/entities/command_outcome.dart';
import 'package:baseer/features/voice_assistant/domain/interaction/spoken_reply.dart';
import 'package:baseer/features/voice_assistant/domain/interaction/standby_control.dart';
import 'package:baseer/features/voice_assistant/domain/interaction/utterance_processor.dart';
import 'package:baseer/features/voice_assistant/domain/interaction/voice_phase.dart';
import 'package:baseer/features/voice_assistant/presentation/cubit/voice_interaction_cubit.dart';

import 'package:flutter_test/flutter_test.dart';

class _FakeStandby implements StandbyControl {
  final List<String> calls = [];

  @override
  Future<void> start() async => calls.add('start');

  @override
  Future<void> stop() async => calls.add('stop');
}

class _FakeSpeech implements SpokenReply {
  final List<String> said = [];
  Completer<void> _quiet = Completer<void>();
  int stops = 0;

  void finish() {
    if (!_quiet.isCompleted) _quiet.complete();
  }

  @override
  Future<void> say(String text, {required String languageCode}) {
    said.add(text);
    _quiet = Completer<void>();
    return _quiet.future;
  }

  @override
  Future<void> whenIdle() {
    _quiet = Completer<void>();
    return _quiet.future;
  }

  @override
  Future<void> stop() async {
    stops++;
    finish();
  }
}

class _FakeCues implements CueOutput {
  final List<FeedbackCue> played = [];

  @override
  Future<void> play(FeedbackCue cue) async => played.add(cue);

  @override
  Future<void> cancel() async {}
}

class _IdleCapture implements AudioCapture {
  @override
  bool get isCapturing => false;

  @override
  Stream<Uint8List> get chunks => const Stream<Uint8List>.empty();

  @override
  Stream<Failure> get failures => const Stream<Failure>.empty();

  @override
  Future<Result<void>> start() async => const ResultSuccess<void>(null);

  @override
  Future<Result<AudioClip>> stop() async =>
      ResultSuccess<AudioClip>(AudioClip(Uint8List(0)));

  @override
  Future<void> cancel() async {}

  @override
  Future<void> dispose() async {}
}

/// Records until the test finishes it, or until it is cancelled.
class _FakeRecorder extends UtteranceRecorder {
  _FakeRecorder() : super(_IdleCapture());

  Completer<Result<AudioClip>>? _pending;
  int recordings = 0;

  void finishWith(Result<AudioClip> result) => _pending?.complete(result);

  @override
  Future<Result<AudioClip>> record({TaskCancelToken? cancel}) {
    recordings++;
    final pending = Completer<Result<AudioClip>>();
    _pending = pending;
    cancel?.whenCancelled.then((_) {
      if (!pending.isCompleted) {
        pending.complete(const ResultFailure<AudioClip>(CancelledFailure()));
      }
    });
    return pending.future;
  }
}

class _FakeProcessor implements UtteranceProcessor {
  _FakeProcessor(this.reply);

  Result<CommandOutcome> reply;
  int calls = 0;

  @override
  Future<Result<CommandOutcome>> process(
    AudioClip clip, {
    required TaskCancelToken cancel,
  }) async {
    calls++;
    return reply;
  }
}

void main() {
  late _FakeStandby standby;
  late _FakeSpeech speech;
  late _FakeCues cues;
  late _FakeRecorder recorder;
  late _FakeProcessor processor;
  late ErrorSupervisor supervisor;
  late StreamController<void> wake;
  late TaskController tasks;
  late bool wakeEnabled;
  late VoiceInteractionCubit cubit;

  final clip = AudioClip(Uint8List.fromList([1, 2, 3, 4]));

  setUp(() {
    standby = _FakeStandby();
    speech = _FakeSpeech();
    cues = _FakeCues();
    recorder = _FakeRecorder();
    processor = _FakeProcessor(
      const ResultSuccess<CommandOutcome>(CommandOutcome(spoken: 'Hello')),
    );
    supervisor = ErrorSupervisor();
    wake = StreamController<void>.broadcast();
    tasks = TaskController();
    wakeEnabled = true;
    cubit = VoiceInteractionCubit(
      standby: standby,
      speech: speech,
      cues: cues,
      tasks: tasks,
      processor: processor,
      newRecorder: () => recorder,
      supervisor: supervisor,
      languageCode: () => 'en',
      wakeWords: wake.stream,
      wakeWordEnabled: () => wakeEnabled,
    );
  });

  tearDown(() async {
    await cubit.close();
    await wake.close();
    tasks.dispose();
    await supervisor.dispose();
  });

  Future<void> pump() => pumpEventQueue();

  test(
    'a full turn: wake word, record, process, speak, standby again',
    () async {
      cubit.startStandby();
      await pump();
      expect(standby.calls, ['start']);

      wake.add(null);
      await pump();
      expect(cubit.state.phase, VoicePhase.listening);
      expect(standby.calls, ['start', 'stop']);
      expect(cues.played, [FeedbackCue.listening]);
      expect(recorder.recordings, 1);

      recorder.finishWith(ResultSuccess<AudioClip>(clip));
      await pump();
      expect(cubit.state.phase, VoicePhase.speaking);
      expect(processor.calls, 1);
      expect(speech.said, ['Hello']);
      expect(cues.played, [FeedbackCue.listening, FeedbackCue.done]);

      speech.finish();
      await pump();
      expect(cubit.state.phase, VoicePhase.idle);
      expect(standby.calls, ['start', 'stop', 'start']);
    },
  );

  test('the wake word is ignored when the setting is off', () async {
    wakeEnabled = false;
    cubit.startStandby();
    await pump();

    wake.add(null);
    await pump();

    expect(cubit.state.phase, VoicePhase.idle);
    expect(recorder.recordings, 0);
  });

  test(
    'tapping while listening cancels and gives the microphone back',
    () async {
      cubit.startStandby();
      await pump();
      cubit.tap();
      await pump();
      expect(cubit.state.phase, VoicePhase.listening);

      cubit.tap();
      await pump();

      expect(cubit.state.phase, VoicePhase.idle);
      expect(standby.calls, ['start', 'stop', 'start']);
      expect(processor.calls, 0);
    },
  );

  test('a recording that fails is announced and ends back at idle', () async {
    final reports = <ErrorReport>[];
    final sub = supervisor.reports.listen(reports.add);
    cubit.tap();
    await pump();

    recorder.finishWith(
      const ResultFailure<AudioClip>(SpeechFailure.noInput()),
    );
    await pump();

    expect(cubit.state.phase, VoicePhase.speaking);
    expect(cubit.state.failure, const SpeechFailure.noInput());
    expect(reports.single.failure, const SpeechFailure.noInput());

    speech.finish();
    await pump();
    expect(cubit.state.phase, VoicePhase.idle);
    expect(cubit.state.failure, isNull);
    await sub.cancel();
  });

  test(
    'tapping while speaking cuts the answer off and listens again',
    () async {
      cubit.tap();
      await pump();
      recorder.finishWith(ResultSuccess<AudioClip>(clip));
      await pump();
      expect(cubit.state.phase, VoicePhase.speaking);

      cubit.tap();
      await pump();

      expect(speech.stops, 1);
      expect(cubit.state.phase, VoicePhase.listening);
      expect(recorder.recordings, 2);
    },
  );
}
