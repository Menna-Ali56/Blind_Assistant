import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/errors/errors.dart';
import '../../../permissions/domain/entities/permission_kind.dart';
import '../../../permissions/domain/repositories/permission_repository.dart';
import '../../domain/interaction/voice_interaction_state.dart';
import '../../domain/interaction/voice_phase.dart';
import '../cubit/voice_interaction_cubit.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  late final VoiceInteractionCubit _voice;
  late final PermissionRepository _permissionRepository;

  String? _permissionMessage;

  @override
  void initState() {
    super.initState();
    _voice = sl<VoiceInteractionCubit>();
    _permissionRepository = sl<PermissionRepository>();
    _startStandbyIfAllowed();
  }

  @override
  void dispose() {
    _voice
      ..cancel()
      ..stopStandby();
    super.dispose();
  }

  Future<void> _startStandbyIfAllowed() async {
    final status = await _permissionRepository.statusOf(
      PermissionKind.microphone,
    );
    if (status.isGranted && mounted) _voice.startStandby();
  }

  Future<void> _onTap() async {
    // Stopping needs no permission check.
    if (_voice.state.phase != VoicePhase.idle) {
      _voice.tap();
      return;
    }
    final permitted = await _ensureMicrophonePermission();
    if (!permitted || !mounted) return;
    setState(() => _permissionMessage = null);
    _voice
      ..startStandby()
      ..tap();
  }

  Future<bool> _ensureMicrophonePermission() async {
    var status = await _permissionRepository.statusOf(
      PermissionKind.microphone,
    );

    if (!status.isGranted) {
      if (status.isBlocked) {
        if (!mounted) return false;
        final openSettings = await _showPermissionDialog();
        if (openSettings) {
          await _permissionRepository.openSettings();
        }
        return false;
      }

      status = await _permissionRepository.request(PermissionKind.microphone);
    }

    if (status.isGranted) return true;

    if (mounted) {
      setState(() {
        _permissionMessage = status.isBlocked
            ? 'Microphone access is blocked. Enable it in Settings.'
            : 'Microphone permission was not granted.';
      });
    }
    return false;
  }

  Future<bool> _showPermissionDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Microphone permission required'),
            content: const Text(
              'Allow microphone access from your device settings to use voice recording.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Not now'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Open settings'),
              ),
            ],
          ),
        ) ??
        false;
  }

  String _title(VoiceInteractionState state) => switch (state.phase) {
    VoicePhase.idle => 'Tap to speak',
    VoicePhase.listening => 'Listening...',
    VoicePhase.processing => 'Working on it...',
    VoicePhase.speaking =>
      state.failure == null ? 'Speaking...' : 'Something went wrong',
  };

  String _details(VoiceInteractionState state) {
    final failure = state.failure;
    return switch (state.phase) {
      VoicePhase.idle =>
        _permissionMessage ??
            (state.standby
                ? 'Say “Hey Baseer” or tap the microphone.'
                : 'Tap the microphone to start speaking.'),
      VoicePhase.listening => 'Speak now. I stop when you are quiet.',
      VoicePhase.processing => 'Tap to cancel.',
      VoicePhase.speaking =>
        failure == null
            ? 'Tap to interrupt and speak.'
            : ErrorPresentation.from(
                failure,
                languageCode: 'en',
                messages: const ErrorMessageMapper(),
              ).spoken,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 44,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'READY WHEN YOU ARE',
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.primary,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Voice assistant', style: textTheme.headlineMedium),
                    const SizedBox(height: 36),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 27,
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          child: const Icon(
                            Icons.visibility_outlined,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: colors.surfaceContainer,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: colors.outlineVariant),
                            ),
                            child: Text(
                              'Hi! I’m Baseer. How can I help you?',
                              style: textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 68),
                      child: Icon(
                        Icons.graphic_eq,
                        color: colors.primary,
                        size: 28,
                        semanticLabel: 'Voice assistant',
                      ),
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child:
                          BlocBuilder<
                            VoiceInteractionCubit,
                            VoiceInteractionState
                          >(
                            bloc: _voice,
                            builder: (context, state) {
                              final idle = state.phase == VoicePhase.idle;
                              final listening =
                                  state.phase == VoicePhase.listening;
                              final working =
                                  state.phase == VoicePhase.processing;
                              return Column(
                                children: [
                                  Semantics(
                                    button: true,
                                    label: idle
                                        ? 'Start voice recording'
                                        : 'Stop voice assistant',
                                    hint: idle
                                        ? 'Double tap to start recording'
                                        : 'Double tap to stop',
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: _onTap,
                                      child: Container(
                                        width: 224,
                                        height: 224,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colors.primary.withValues(
                                            alpha: 0.08,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 174,
                                          height: 174,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: colors.surfaceContainer,
                                            border: Border.all(
                                              color: colors.primary.withValues(
                                                alpha: 0.35,
                                              ),
                                              width: 2,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: 126,
                                            height: 126,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: listening
                                                  ? colors.error
                                                  : colors.primary,
                                            ),
                                            child: Center(
                                              child: working
                                                  ? SizedBox(
                                                      width: 34,
                                                      height: 34,
                                                      child:
                                                          CircularProgressIndicator(
                                                            color: colors
                                                                .onPrimary,
                                                          ),
                                                    )
                                                  : Icon(
                                                      idle
                                                          ? Icons
                                                                .mic_none_rounded
                                                          : Icons.stop_rounded,
                                                      size: 54,
                                                      color: colors.onPrimary,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    _title(state),
                                    style: textTheme.headlineSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _details(state),
                                    textAlign: TextAlign.center,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
