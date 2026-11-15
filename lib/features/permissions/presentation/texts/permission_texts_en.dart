import '../../../../core/errors/messages/error_messages_en.dart';
import '../../domain/entities/permission_kind.dart';
import 'permission_texts.dart';

const PermissionTexts englishPermissionTexts = PermissionTexts(
  labels: englishPermissionLabels,
  purposes: {
    PermissionKind.camera:
        'Baseer uses the camera to read text and recognize objects and '
        'banknotes around you. Nothing is sent without your consent.',
    PermissionKind.microphone:
        'Baseer uses the microphone to understand your voice commands. '
        'Your voice is not saved.',
    PermissionKind.location:
        'Baseer uses your location to guide you while you walk.',
  },
  title: 'App permissions',
  allowedTemplate: 'The {label} permission is allowed.',
  deniedTemplate: 'The {label} permission was not allowed. You can try again.',
  blockedTemplate:
      'The {label} permission is blocked. Open phone settings to allow it.',
  allowAction: 'Allow',
  notNowAction: 'Not now',
  settingsAction: 'Open settings',
  allowHint: 'Tap Allow to continue.',
  doneMessage: 'The permissions are ready.',
);
