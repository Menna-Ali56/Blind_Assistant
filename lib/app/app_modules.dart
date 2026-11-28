import '../core/audio/audio_module.dart';
import '../core/auth/auth_module.dart';
import '../core/di/di_module.dart';
import '../core/errors/errors_module.dart';
import '../core/execution/execution_module.dart';
import '../core/feedback/feedback_module.dart';
import '../core/network/network_module.dart';
import '../core/output/output_module.dart';
import '../core/storage/storage_module.dart';
import '../core/tasks/tasks_module.dart';

import '../features/camera/camera_module.dart';
import '../features/camera_capture/camera_capture_module.dart';
import '../features/consent/consent_module.dart';
import '../features/ocr/quality_gate_module.dart';
import '../features/permissions/permissions_module.dart';
import '../features/settings/settings_module.dart';
import '../features/theme/theme_module.dart';
import '../features/text_to_speech/text_to_speech_module.dart';

import '../features/voice_assistant/data/sherpa_module.dart';
import '../features/voice_assistant/navigation_commands.dart';
import '../features/voice_assistant/settings_commands/settings_commands.dart';
import '../features/voice_assistant/spotter_module.dart';
import '../features/voice_assistant/voice_assistant_module.dart';
import '../features/voice_assistant/voice_capture_module.dart';
import '../features/voice_assistant/voice_interaction_module.dart';

import 'environment_module.dart';
import 'navigation_module.dart';
import 'safety_module.dart';

const List<DiModule> appModules = [
  ErrorsModule(),

  // Text-to-Speech must be registered before OutputModule.
  TextToSpeechModule(),
  OutputModule(),

  FeedbackModule(),
  AuthModule(),
  NetworkModule(),
  StorageModule(),
  ThemeModule(),
  PermissionsModule(),
  CameraModule(),
  CameraCaptureModule(),
  ConsentModule(),
  ExecutionModule(),
  EnvironmentModule(),
  NavigationModule(),
  TasksModule(),
  QualityGateModule(),
  SettingsModule(),

  VoiceAssistantModule(),
  NavigationCommandsModule(),
  SettingsCommandsModule(),
  SafetyModule(),

  SherpaModule(),
  SpotterModule(),
  AudioModule(),
  VoiceCaptureModule(),
  VoiceInteractionModule(),
];
