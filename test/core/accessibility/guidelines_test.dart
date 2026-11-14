import 'package:baseer/core/accessibility/screen_reader_status.dart';
import 'package:baseer/core/consent/consent.dart';
import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/output/output.dart';
import 'package:baseer/core/storage/storage.dart';
import 'package:baseer/core/theme/app_theme.dart';
import 'package:baseer/features/consent/consent.dart';
import 'package:baseer/features/consent/data/repositories/consent_repository_impl.dart';
import 'package:baseer/features/consent/presentation/pages/consent_flow_page.dart';
import 'package:baseer/features/home/presentation/pages/home_page.dart';
import 'package:baseer/features/permissions/data/repositories/in_memory_permission_flow_progress.dart';
import 'package:baseer/features/permissions/domain/repositories/permission_repository.dart';
import 'package:baseer/features/permissions/permissions.dart';
import 'package:baseer/features/permissions/presentation/pages/permission_flow_page.dart';
import 'package:baseer/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:baseer/features/settings/domain/usecases/delete_user_data.dart';
import 'package:baseer/features/settings/domain/usecases/load_settings.dart';
import 'package:baseer/features/settings/domain/usecases/save_settings.dart';
import 'package:baseer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:baseer/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _DeniedPermissions implements PermissionRepository {
  @override
  Future<AccessStatus> statusOf(PermissionKind kind) async =>
      AccessStatus.denied;

  @override
  Future<Map<PermissionKind, AccessStatus>> statuses() async => {
    for (final kind in PermissionKind.values) kind: AccessStatus.denied,
  };

  @override
  Future<AccessStatus> request(PermissionKind kind) async =>
      AccessStatus.denied;

  @override
  Future<bool> openSettings() async => true;
}

class _ActiveReader implements ScreenReaderStatus {
  const _ActiveReader();

  @override
  bool get isActive => true;
}

Future<void> _checkPage(
  WidgetTester tester,
  ThemeData theme,
  Widget page,
) async {
  final handle = tester.ensureSemantics();
  try {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(theme: theme, home: page));
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  } finally {
    handle.dispose();
  }
}

void main() {
  final themes = <String, ThemeData>{
    'standard': AppTheme.standard,
    'highContrast': AppTheme.highContrast,
  };

  for (final entry in themes.entries) {
    group('${entry.key} theme accessibility guidelines', () {
      testWidgets(
        'HomePage',
        (tester) => _checkPage(tester, entry.value, const HomePage()),
      );

      testWidgets('PermissionFlowPage', (tester) async {
        final cubit = PermissionsCubit(
          repository: _DeniedPermissions(),
          granted: GrantedPermissions(),
          progress: InMemoryPermissionFlowProgress(),
          output: OutputCoordinator(const SilentOutputChannel()),
          languageCode: () => 'en',
          screenReader: const _ActiveReader(),
        );
        addTearDown(cubit.close);
        await cubit.refresh();
        await _checkPage(
          tester,
          entry.value,
          BlocProvider.value(value: cubit, child: const PermissionFlowPage()),
        );
      });

      testWidgets('ConsentFlowPage', (tester) async {
        final cubit = ConsentCubit(
          repository: ConsentRepositoryImpl(InMemorySecureStore()),
          granted: GrantedConsent(),
          output: OutputCoordinator(const SilentOutputChannel()),
          languageCode: () => 'en',
          screenReader: const _ActiveReader(),
        );
        addTearDown(cubit.close);
        await cubit.load();
        await _checkPage(
          tester,
          entry.value,
          BlocProvider.value(value: cubit, child: const ConsentFlowPage()),
        );
      });

      testWidgets('SettingsPage', (tester) async {
        final store = InMemorySecureStore();
        final repo = SettingsRepositoryImpl(store);
        final supervisor = ErrorSupervisor();
        addTearDown(supervisor.dispose);
        final settings = SettingsCubit(
          loadSettings: LoadSettings(repo),
          saveSettings: SaveSettings(repo),
          deleteUserData: DeleteUserData(repo),
          supervisor: supervisor,
        );
        final consent = ConsentCubit(
          repository: ConsentRepositoryImpl(store),
          granted: GrantedConsent(),
          output: OutputCoordinator(const SilentOutputChannel()),
          languageCode: () => 'en',
          screenReader: const _ActiveReader(),
        );
        addTearDown(settings.close);
        addTearDown(consent.close);
        await settings.load();
        await consent.load();
        await _checkPage(
          tester,
          entry.value,
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: settings),
              BlocProvider.value(value: consent),
            ],
            child: const SettingsPage(),
          ),
        );
      });
    });
  }
}
