import 'package:equatable/equatable.dart';

import '../../domain/entities/access_status.dart';
import '../../domain/entities/permission_kind.dart';

class PermissionsState extends Equatable {
  const PermissionsState({
    this.statuses = const {},
    this.skipped = const {},
    this.loaded = false,
  });

  final Map<PermissionKind, AccessStatus> statuses;
  final Set<PermissionKind> skipped;
  final bool loaded;

  AccessStatus statusOf(PermissionKind kind) =>
      statuses[kind] ?? AccessStatus.denied;

  PermissionKind? get pending => PermissionKind.values
      .where((kind) => !statusOf(kind).isGranted && !skipped.contains(kind))
      .firstOrNull;

  bool get isComplete => loaded && pending == null;

  PermissionsState copyWith({
    Map<PermissionKind, AccessStatus>? statuses,
    Set<PermissionKind>? skipped,
    bool? loaded,
  }) {
    return PermissionsState(
      statuses: statuses ?? this.statuses,
      skipped: skipped ?? this.skipped,
      loaded: loaded ?? this.loaded,
    );
  }

  @override
  List<Object> get props => [statuses, skipped, loaded];
}
