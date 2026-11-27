import 'dart:async';

import '../../../../core/audio/audio_format.dart';
import '../../../../core/audio/utterance_recorder.dart';
import '../../../../core/cubit/base_cubit.dart';
import '../../../../core/errors/errors.dart';
import '../../../../core/feedback/cue_output.dart';
import '../../../../core/tasks/task_controller.dart';
import '../../../../core/tasks/task_handle.dart';
import '../../domain/entities/command_outcome.dart';
import '../../domain/interaction/spoken_reply.dart';
import '../../domain/interaction/standby_control.dart';
import '../../domain/interaction/utterance_processor.dart';
import '../../domain/interaction/voice_effect.dart';
import '../../domain/interaction/voice_event.dart';
import '../../domain/interaction/voice_interaction_state.dart';
import '../../domain/interaction/voice_state_machine.dart';

bool _always() => true;

class VoiceInteractionCubit extends BaseCubit<VoiceInteractionState> {
  VoiceInteractionCubit({
    required this._standby,
    required this._speech,
    required this._cues,
    required this._tasks,
    required this._processor,
    required this._newRecorder,
    required this._supervisor,
    required this._languageCode,
    Stream<void> wakeWords = const Stream<void>.empty(),
    Stream<void> interruptions = const Stream<void>.empty(),
    this._wakeWordEnabled = _always,
    this.processingTimeout = defaultProcessingTimeout,
  }) : super(const VoiceInteractionState()) {
    _wakeSub = wakeWords.listen(_onWake);
    _interruptSub = interruptions.listen((_) => dispatch(const Interrupted()));
  }

  static const Duration defaultProcessingTimeout = Duration(seconds: 20);

  static const Duration releaseTimeout = Duration(seconds: 2);

  static const String captureKey = 'voice_capture';
  static const String processKey = 'voice_process';
  static const String reportSource = 'voice_interaction';

  final StandbyControl _standby;
  final SpokenReply _speech;
  final CueOutput _cues;
  final TaskController _tasks;
  final UtteranceProcessor _processor;
  final UtteranceRecorder Function() _newRecorder;
  final ErrorSupervisor _supervisor;
  final String Function() _languageCode;
  final bool Function() _wakeWordEnabled;
  final Duration processingTimeout;

  late final StreamSubscription<void> _wakeSub;
  late final StreamSubscription<void> _interruptSub;

  Future<void> _effects = Future<void>.value();
  TaskHandle<Result<AudioClip>>? _captureHandle;
  Future<void>? _captureReleased;
  TaskHandle<Result<CommandOutcome>>? _processHandle;

  int _speechRun = 0;

  void startStandby() => dispatch(const StandbyRequested());

  void stopStandby() => dispatch(const StandbyReleased());

  void tap() => dispatch(const TapPressed());

  void cancel() => dispatch(const CancelRequested());

  void dispatch(VoiceEvent event) {
    if (isClosed) return;
    final transition = VoiceStateMachine.next(state, event);
    safeEmit(transition.state);
    if (transition.effects.isEmpty) return;
    final effects = transition.effects;
    // One list at a time, in order. _run never throws, so the chain survives.
    _effects = _effects.then((_) => _run(effects));
  }

  @override
  Future<void> close() async {
    await _wakeSub.cancel();
    await _interruptSub.cancel();
    _captureHandle?.cancel();
    _processHandle?.cancel();
    _captureHandle = null;
    _processHandle = null;
    _speechRun++;
    await _guard(_speech.stop);
    await _guard(_standby.stop);
    return super.close();
  }

  void _onWake(void _) {
    if (_wakeWordEnabled()) dispatch(const WakeHeard());
  }

  Future<void> _run(List<VoiceEffect> effects) async {
    for (final effect in effects) {
      if (isClosed) return;
      try {
        await _perform(effect);
      } catch (error, stackTrace) {
        _report(error, stackTrace);
        // Never get stuck in a phase whose work could not start.
        dispatch(const CancelRequested());
      }
    }
  }

  Future<void> _perform(VoiceEffect effect) async {
    switch (effect) {
      case StartStandby():
        await _standby.start();
      case StopStandby():
        await _standby.stop();
      case PlayCue(:final cue):
        await _cues.play(cue);
      case BeginCapture():
        _beginCapture();
      case CancelCapture():
        await _cancelCapture();
      case ProcessClip(:final clip):
        _beginProcessing(clip);
      case CancelProcessing():
        _processHandle?.cancel();
        _processHandle = null;
      case Speak(:final text):
        _beginSpeaking(text);
      case StopSpeech():
        _speechRun++;
        await _speech.stop();
      case ReportFailure(:final failure):
        _supervisor.reportFailure(failure, source: reportSource);
      case AwaitSpeech():
        _awaitSpeech();
    }
  }

  void _beginCapture() {
    final released = Completer<void>();
    _captureReleased = released.future;
    final handle = _tasks.start<Result<AudioClip>>((token) async {
      try {
        return await _newRecorder().record(cancel: token);
      } finally {
        released.complete();
      }
    }, key: captureKey);
    _captureHandle = handle;
    unawaited(
      handle.result.then((outer) {
        // Cancelled or replaced by us: the state machine already moved on.
        if (!identical(_captureHandle, handle)) return;
        _captureHandle = null;
        _flatten(outer).fold<void>(
          onSuccess: (clip) => dispatch(CaptureCompleted(clip)),
          onFailure: (failure) => dispatch(CaptureFailed(failure)),
        );
      }),
    );
  }

  Future<void> _cancelCapture() async {
    _captureHandle?.cancel();
    _captureHandle = null;
    final released = _captureReleased;
    _captureReleased = null;
    if (released == null) return;
    await released.timeout(releaseTimeout, onTimeout: () {});
  }

  void _beginProcessing(AudioClip clip) {
    final handle = _tasks.start<Result<CommandOutcome>>(
      (token) => _processor.process(clip, cancel: token),
      key: processKey,
      timeout: processingTimeout,
    );
    _processHandle = handle;
    unawaited(
      handle.result.then((outer) {
        if (!identical(_processHandle, handle)) return;
        _processHandle = null;
        _flatten(outer).fold<void>(
          onSuccess: (outcome) => dispatch(ReplyReady(outcome)),
          onFailure: (failure) => dispatch(ProcessingFailed(failure)),
        );
      }),
    );
  }

  void _beginSpeaking(String text) {
    final run = ++_speechRun;
    unawaited(
      _untilQuiet(run, () => _speech.say(text, languageCode: _languageCode())),
    );
  }

  void _awaitSpeech() {
    final run = ++_speechRun;
    unawaited(_untilQuiet(run, _speech.whenIdle));
  }

  Future<void> _untilQuiet(int run, Future<void> Function() speak) async {
    try {
      await speak();
    } catch (error, stackTrace) {
      _report(error, stackTrace);
    }
    if (run == _speechRun) dispatch(const SpeechEnded());
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (error, stackTrace) {
      _report(error, stackTrace);
    }
  }

  void _report(Object error, StackTrace stackTrace) {
    try {
      _supervisor.report(error, stackTrace: stackTrace, source: reportSource);
    } catch (_) {}
  }
}

Result<T> _flatten<T>(Result<Result<T>> outer) => outer.fold<Result<T>>(
  onSuccess: (inner) => inner,
  onFailure: (failure) => ResultFailure<T>(failure),
);
