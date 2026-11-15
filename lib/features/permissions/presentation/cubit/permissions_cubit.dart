import '../../../../core/accessibility/screen_reader_status.dart';
import '../../../../core/cubit/base_cubit.dart';
import '../../../../core/output/output.dart';
import '../../domain/entities/access_status.dart';
import '../../domain/entities/granted_permissions.dart';
import '../../domain/entities/permission_kind.dart';
import '../../domain/repositories/permission_flow_progress.dart';
import '../../domain/repositories/permission_repository.dart';
import '../texts/permission_texts.dart';
import '../texts/permission_texts_lookup.dart';
import 'permissions_state.dart';

class PermissionsCubit extends BaseCubit<PermissionsState> {
  PermissionsCubit({
    required this.repository,
    required this.granted,
    required this.progress,
    required this.output,
    required this.languageCode,
    this.screenReader = const PlatformScreenReaderStatus(),
  }) : super(const PermissionsState());

  static const String ownerId = 'permissions';

  final PermissionRepository repository;
  final GrantedPermissions granted;
  final PermissionFlowProgress progress;
  final OutputCoordinator output;
  final String Function() languageCode;
  final ScreenReaderStatus screenReader;

  PermissionTexts get texts => permissionTextsFor(languageCode());

  Future<void> refresh() =>
      _guard(() async => _apply(await repository.statuses()));

  Future<void> request(PermissionKind kind) => _guard(() async {
    final result = await repository.request(kind);
    _apply({kind: result});
    if (!result.isGranted) _say(texts.statusMessage(kind, result));
  });

  Future<void> openSettings() => _guard(repository.openSettings);

  void skip(PermissionKind kind) =>
      safeEmit(state.copyWith(skipped: {...state.skipped, kind}));

  void announce(PermissionKind kind) {
    if (screenReader.isActive) return;
    _say(texts.announcement(kind, state.statusOf(kind)));
  }

  Future<bool> needsFlow() async {
    if (progress.isCompleted) return false;
    await refresh();
    if (state.isComplete) progress.markCompleted();
    return !progress.isCompleted;
  }

  void finish() {
    progress.markCompleted();
    _say(texts.doneMessage);
  }

  void _apply(Map<PermissionKind, AccessStatus> latest) {
    final merged = {...state.statuses, ...latest};
    final gained = [
      for (final entry in latest.entries)
        if (state.loaded &&
            entry.value.isGranted &&
            !state.statusOf(entry.key).isGranted)
          entry.key,
    ];
    granted.update(merged);
    safeEmit(state.copyWith(statuses: merged, loaded: true));
    for (final kind in gained) {
      _say(texts.statusMessage(kind, AccessStatus.granted));
    }
  }

  void _say(String text) => output.submit(
    OutputMessage(
      text: text,
      languageCode: languageCode(),
      priority: OutputPriority.high,
      key: ownerId,
      ownerId: ownerId,
    ),
  );

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }
}
