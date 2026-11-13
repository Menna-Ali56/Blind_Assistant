import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/features/settings/domain/entities/app_settings.dart';
import 'package:baseer/features/settings/domain/repositories/settings_repository.dart';
import 'package:baseer/features/settings/domain/usecases/delete_user_data.dart';
import 'package:baseer/features/settings/domain/usecases/load_settings.dart';
import 'package:baseer/features/settings/domain/usecases/save_settings.dart';
import 'package:baseer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:baseer/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MemoryRepository implements SettingsRepository {
  AppSettings stored = const AppSettings();

  @override
  Future<Result<AppSettings>> load() async =>
      ResultSuccess<AppSettings>(stored);

  @override
  Future<Result<void>> save(AppSettings settings) async {
    stored = settings;
    return const ResultSuccess<void>(null);
  }

  @override
  Future<Result<void>> deleteAll() async {
    stored = const AppSettings();
    return const ResultSuccess<void>(null);
  }
}

void main() {
  late SettingsCubit cubit;
  late ErrorSupervisor supervisor;

  setUp(() {
    final repository = MemoryRepository();
    supervisor = ErrorSupervisor();
    cubit = SettingsCubit(
      loadSettings: LoadSettings(repository),
      saveSettings: SaveSettings(repository),
      deleteUserData: DeleteUserData(repository),
      supervisor: supervisor,
    );
  });

  tearDown(() async {
    await cubit.close();
    await supervisor.dispose();
  });

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await cubit.load();
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsCubit>.value(
          value: cubit,
          child: const SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows every setting with its current value', (tester) async {
    await pumpPage(tester);

    for (final label in [
      'Voice speed',
      'Text size',
      'High contrast',
      'Vibration',
      'Send photos',
      'Delete my data',
    ]) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('Not allowed'), findsOneWidget);
  });

  testWidgets('tapping a row changes its value', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('Voice speed'));
    await tester.pumpAndSettle();

    expect(find.text('Fast'), findsOneWidget);
  });

  testWidgets('rows are buttons with a spoken name and value', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpPage(tester);

    expect(find.bySemanticsLabel('Voice speed, Normal'), findsOneWidget);
    expect(find.bySemanticsLabel('Send photos, Not allowed'), findsOneWidget);

    handle.dispose();
  });

  testWidgets('deleting asks first and then shows the done screen', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.text('Delete my data'));
    await tester.pumpAndSettle();
    expect(find.text('Delete your data?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Data deleted'), findsOneWidget);

    await tester.tap(find.text('Back to settings'));
    await tester.pumpAndSettle();
    expect(find.text('Voice speed'), findsOneWidget);
  });

  testWidgets('cancelling the dialog keeps everything', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('Delete my data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Data deleted'), findsNothing);
    expect(find.text('Voice speed'), findsOneWidget);
  });
}
