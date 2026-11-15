import 'package:baseer/core/consent/consent.dart';
import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/core/output/output.dart';
import 'package:baseer/core/storage/in_memory_secure_store.dart';
import 'package:baseer/features/consent/consent.dart';
import 'package:baseer/features/consent/data/repositories/consent_repository_impl.dart';
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
  late ConsentCubit consentCubit;
  late GrantedConsent grantedConsent;
  late ErrorSupervisor supervisor;

  setUp(() {
    final repository = MemoryRepository();
    supervisor = ErrorSupervisor();
    grantedConsent = GrantedConsent();
    cubit = SettingsCubit(
      loadSettings: LoadSettings(repository),
      saveSettings: SaveSettings(repository),
      deleteUserData: DeleteUserData(repository),
      supervisor: supervisor,
    );
    consentCubit = ConsentCubit(
      repository: ConsentRepositoryImpl(InMemorySecureStore()),
      granted: grantedConsent,
      output: OutputCoordinator(const SilentOutputChannel()),
      languageCode: () => 'en',
    );
  });

  tearDown(() async {
    await cubit.close();
    await consentCubit.close();
    await supervisor.dispose();
  });

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await cubit.load();
    await consentCubit.load();
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<SettingsCubit>.value(value: cubit),
            BlocProvider<ConsentCubit>.value(value: consentCubit),
          ],
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
      'Send audio',
      'Share location',
      'Delete my data',
    ]) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('Not allowed'), findsNWidgets(3));
  });

  testWidgets('tapping a row changes its value', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('Voice speed'));
    await tester.tap(find.text('Send photos'));
    await tester.pumpAndSettle();

    expect(find.text('Fast'), findsOneWidget);
    expect(grantedConsent.allows(ConsentScope.imageUpload), isTrue);
  });

  testWidgets('rows are buttons with a spoken name and value', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpPage(tester);

    expect(find.bySemanticsLabel('Voice speed, Normal'), findsOneWidget);
    expect(find.bySemanticsLabel('Send photos, Not allowed'), findsOneWidget);
    expect(find.bySemanticsLabel('Send audio, Not allowed'), findsOneWidget);

    handle.dispose();
  });

  testWidgets('deleting asks first and then shows the done screen', (
    tester,
  ) async {
    await pumpPage(tester);
    await consentCubit.toggle(ConsentScope.audioUpload);
    expect(grantedConsent.allows(ConsentScope.audioUpload), isTrue);

    await tester.tap(find.text('Delete my data'));
    await tester.pumpAndSettle();
    expect(find.text('Delete your data?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Data deleted'), findsOneWidget);
    expect(grantedConsent.allows(ConsentScope.audioUpload), isFalse);

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
