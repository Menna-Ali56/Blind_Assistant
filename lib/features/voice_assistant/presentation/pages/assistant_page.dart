import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/audio/audio_capture.dart';
import '../../../../core/errors/errors.dart';
import '../../../../core/di/injector.dart';

import '../../../permissions/domain/entities/permission_kind.dart';
import '../../../permissions/domain/repositories/permission_repository.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  late final AudioCapture _audioCapture;
  late final PermissionRepository _permissionRepository;

  StreamSubscription<Uint8List>? _chunksSubscription;
  StreamSubscription<Failure>? _failuresSubscription;
  Timer? _elapsedTimer;

  bool _isStarting = false;
  bool _isRecording = false;
  int _receivedBytes = 0;
  int _elapsedSeconds = 0;
  String _statusMessage = 'Tap the microphone to start speaking';
  String? _lastRecordingSummary;

  @override
  void initState() {
    super.initState();
    _audioCapture = sl<AudioCapture>();
    _permissionRepository = sl<PermissionRepository>();
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    _chunksSubscription?.cancel();
    _failuresSubscription?.cancel();

    if (_audioCapture.isCapturing) {
      unawaited(_audioCapture.cancel());
    }
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isStarting) return;

    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
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
        _statusMessage = status.isBlocked
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

  Future<void> _startRecording() async {
    setState(() {
      _isStarting = true;
      _statusMessage = 'Checking microphone permission...';
      _lastRecordingSummary = null;
      _receivedBytes = 0;
      _elapsedSeconds = 0;
    });

    try {
      final permitted = await _ensureMicrophonePermission();
      if (!permitted || !mounted) return;

      await _chunksSubscription?.cancel();
      await _failuresSubscription?.cancel();

      _chunksSubscription = _audioCapture.chunks.listen((chunk) {
        if (!mounted) return;
        setState(() {
          _receivedBytes += chunk.lengthInBytes;
        });
      });

      _failuresSubscription = _audioCapture.failures.listen((failure) {
        if (!mounted) return;
        _elapsedTimer?.cancel();
        setState(() {
          _isRecording = false;
          _isStarting = false;
          _statusMessage = 'Recording stopped because the microphone failed.';
        });
      });

      final result = await _audioCapture.start();
      if (!mounted) return;

      result.fold(
        onSuccess: (_) {
          setState(() {
            _isRecording = true;
            _statusMessage = 'Listening... Tap the microphone to stop.';
          });
          _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
            if (!mounted) return;
            setState(() => _elapsedSeconds++);
          });
        },
        onFailure: (failure) {
          setState(() {
            _isRecording = false;
            _statusMessage =
                failure.messageKey == 'permission_denied' ||
                    failure.messageKey == 'permission_permanently_denied'
                ? 'Microphone permission is required.'
                : 'Could not start recording. Please try again.';
          });
        },
      );
    } catch (_) {
      if (mounted) {
        setState(() {
          _statusMessage =
              'Something went wrong while starting the microphone.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isStarting = false);
      }
    }
  }

  Future<void> _stopRecording() async {
    _elapsedTimer?.cancel();
    setState(() {
      _isStarting = true;
      _statusMessage = 'Finishing recording...';
    });

    try {
      final result = await _audioCapture.stop();
      if (!mounted) return;

      result.fold(
        onSuccess: (clip) {
          final seconds = clip.duration.inSeconds;
          final bytes = clip.pcm.lengthInBytes;
          setState(() {
            _isRecording = false;
            _receivedBytes = bytes;
            _lastRecordingSummary =
                'Captured $bytes bytes of audio (${clip.duration.inMilliseconds} ms).';
            _statusMessage = clip.isEmpty
                ? 'No audio was captured. Try speaking closer to the microphone.'
                : 'Recording completed successfully.';
            _elapsedSeconds = seconds;
          });
        },
        onFailure: (_) {
          setState(() {
            _isRecording = false;
            _statusMessage = 'There is no active recording to stop.';
          });
        },
      );
    } catch (_) {
      if (mounted) {
        setState(() {
          _isRecording = false;
          _statusMessage = 'Could not stop the recording cleanly.';
        });
      }
    } finally {
      await _chunksSubscription?.cancel();
      await _failuresSubscription?.cancel();
      _chunksSubscription = null;
      _failuresSubscription = null;
      if (mounted) setState(() => _isStarting = false);
    }
  }

  String get _formattedDuration {
    final minutes = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
                      child: Column(
                        children: [
                          Semantics(
                            button: true,
                            label: _isRecording
                                ? 'Stop voice recording'
                                : 'Start voice recording',
                            hint: _isRecording
                                ? 'Double tap to stop recording'
                                : 'Double tap to start recording',
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _isStarting ? null : _toggleRecording,
                              child: Container(
                                width: 224,
                                height: 224,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colors.primary.withValues(alpha: 0.08),
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
                                      color: _isRecording
                                          ? colors.error
                                          : colors.primary,
                                    ),
                                    child: Center(
                                      child: _isStarting
                                          ? SizedBox(
                                              width: 34,
                                              height: 34,
                                              child: CircularProgressIndicator(
                                                color: colors.onPrimary,
                                              ),
                                            )
                                          : Icon(
                                              _isRecording
                                                  ? Icons.stop_rounded
                                                  : Icons.mic_none_rounded,
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
                            _isRecording ? 'Listening...' : 'Tap to speak',
                            style: textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isRecording
                                ? 'Recording time  $_formattedDuration'
                                : _statusMessage,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          if (_lastRecordingSummary != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              _lastRecordingSummary!,
                              textAlign: TextAlign.center,
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.primary,
                              ),
                            ),
                          ],
                          if (_isRecording) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Audio received: $_receivedBytes bytes',
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        Chip(label: Text('“Read this text”')),
                        Chip(label: Text('“What color is this?”')),
                      ],
                    ),
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
