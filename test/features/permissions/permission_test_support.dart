import 'package:baseer/core/accessibility/screen_reader_status.dart';
import 'package:baseer/core/output/output.dart';
import 'package:baseer/features/permissions/data/repositories/in_memory_permission_flow_progress.dart';
import 'package:baseer/features/permissions/domain/repositories/permission_repository.dart';
import 'package:baseer/features/permissions/permissions.dart';

class FakePermissionRepository implements PermissionRepository {
  FakePermissionRepository({Map<PermissionKind, AccessStatus>? current})
    : current =
          current ??
          {for (final kind in PermissionKind.values) kind: AccessStatus.denied};

  final Map<PermissionKind, AccessStatus> current;
  AccessStatus requestResult = AccessStatus.granted;
  int settingsOpened = 0;

  @override
  Future<AccessStatus> statusOf(PermissionKind kind) async => current[kind]!;

  @override
  Future<Map<PermissionKind, AccessStatus>> statuses() async => {...current};

  @override
  Future<AccessStatus> request(PermissionKind kind) async {
    current[kind] = requestResult;
    return requestResult;
  }

  @override
  Future<bool> openSettings() async => ++settingsOpened > 0;
}

class FakeScreenReaderStatus implements ScreenReaderStatus {
  FakeScreenReaderStatus({this.isActive = false});

  @override
  bool isActive;
}

class RecordingChannel implements OutputChannel {
  final List<String> spoken = [];

  @override
  Future<void> speak(
    String text, {
    required String languageCode,
    required OutputPriority priority,
  }) async => spoken.add(text);

  @override
  Future<void> stop() async {}

  @override
  Future<void> haptic(OutputHaptic kind) async {}
}

class PermissionsHarness {
  PermissionsHarness({
    FakePermissionRepository? repository,
    ScreenReaderStatus? screenReader,
  }) : repository = repository ?? FakePermissionRepository() {
    cubit = PermissionsCubit(
      repository: this.repository,
      granted: granted,
      progress: progress,
      output: OutputCoordinator(channel),
      languageCode: () => 'en',
      screenReader: screenReader ?? FakeScreenReaderStatus(),
    );
  }

  final FakePermissionRepository repository;
  final RecordingChannel channel = RecordingChannel();
  final GrantedPermissions granted = GrantedPermissions();
  final InMemoryPermissionFlowProgress progress =
      InMemoryPermissionFlowProgress();
  late final PermissionsCubit cubit;
}
