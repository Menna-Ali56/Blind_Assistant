import 'access_status.dart';
import 'permission_kind.dart';

class GrantedPermissions {
  Set<String> _names = const {};

  Set<String> get names => _names;

  void update(Map<PermissionKind, AccessStatus> statuses) {
    _names = Set.unmodifiable({
      for (final entry in statuses.entries)
        if (entry.value.isGranted) entry.key.key,
    });
  }
}
