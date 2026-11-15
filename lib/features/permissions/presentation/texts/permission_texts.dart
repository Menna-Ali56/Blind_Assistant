import '../../domain/entities/access_status.dart';
import '../../domain/entities/permission_kind.dart';

const String _labelSlot = '{label}';

class PermissionTexts {
  const PermissionTexts({
    required this.labels,
    required this.purposes,
    required this.title,
    required this.allowedTemplate,
    required this.deniedTemplate,
    required this.blockedTemplate,
    required this.allowAction,
    required this.notNowAction,
    required this.settingsAction,
    required this.allowHint,
    required this.doneMessage,
  });

  final Map<String, String> labels;
  final Map<PermissionKind, String> purposes;
  final String title;
  final String allowedTemplate;
  final String deniedTemplate;
  final String blockedTemplate;
  final String allowAction;
  final String notNowAction;
  final String settingsAction;
  final String allowHint;
  final String doneMessage;

  String label(PermissionKind kind) => labels[kind.key]!;

  String purpose(PermissionKind kind) => purposes[kind]!;

  String statusMessage(PermissionKind kind, AccessStatus status) {
    final template = switch (status) {
      AccessStatus.granted => allowedTemplate,
      AccessStatus.denied => deniedTemplate,
      AccessStatus.blocked => blockedTemplate,
    };
    return template.replaceAll(_labelSlot, label(kind));
  }

  String announcement(PermissionKind kind, AccessStatus status) {
    if (status.isBlocked) return statusMessage(kind, status);
    return '${label(kind)}. ${purpose(kind)} $allowHint';
  }
}
