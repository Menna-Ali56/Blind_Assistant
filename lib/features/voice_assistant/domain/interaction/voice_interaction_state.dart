import 'package:equatable/equatable.dart';

import '../../../../core/errors/errors.dart';
import 'voice_phase.dart';

class VoiceInteractionState extends Equatable {
  const VoiceInteractionState({
    this.phase = VoicePhase.idle,
    this.standby = false,
    this.failure,
  });

  final VoicePhase phase;

  final bool standby;

  final Failure? failure;

  bool get isIdle => phase == VoicePhase.idle;

  VoiceInteractionState moveTo(VoicePhase next, {Failure? failure}) =>
      VoiceInteractionState(phase: next, standby: standby, failure: failure);

  VoiceInteractionState withStandby(bool value) =>
      VoiceInteractionState(phase: phase, standby: value, failure: failure);

  @override
  List<Object?> get props => [phase, standby, failure];
}
