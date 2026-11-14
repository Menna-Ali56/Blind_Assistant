import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/features/settings/domain/entities/app_settings.dart';
import 'package:baseer/features/settings/domain/repositories/settings_repository.dart';
import 'package:baseer/features/settings/domain/usecases/delete_user_data.dart';
import 'package:baseer/features/settings/domain/usecases/load_settings.dart';
import 'package:baseer/features/settings/domain/usecases/save_settings.dart';
import 'package:baseer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:baseer/features/settings/presentation/cubit/settings_state.dart';
import 'package:baseer/features/settings/presentation/effects/settings_effect.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeRepository implements SettingsRepository {
  AppSettings stored = const AppSettings();
  bool failLoad = false;
  bool failSave = false;
  bool failDelete = false;
  int deletes = 0;

  @override
  Future<Result<AppSettings>> load() async => failLoad
      ? const ResultFailure<AppSettings>(StorageFailure())
      : ResultSuccess<AppSettings>(stored);

  @override
  Future<Result<void>> save(AppSettings settings) async {
    if (failSave) return const ResultFailure<void>(StorageFailure());
    stored = settings;
    return const ResultSuccess<void>(null);
  }

  @override
  Future<Result<void>> deleteAll() async {
    if (failDelete) return const ResultFailure<void>(StorageFailure());
    deletes++;
    stored = const AppSettings();
    return const ResultSuccess<void>(null);
  }
}

class RecordingEffect implements SettingsEffect {
  final List<AppSettings> applied = [];

  @override
  void apply(AppSettings settings) => applied.add(settings);
}

void main() {
  late FakeRepository repository;
  late RecordingEffect effect;
  late ErrorSupervisor supervisor;
  late SettingsCubit cubit;

  setUp(() {
    repository = FakeRepository();
    effect = RecordingEffect();
    supervisor = ErrorSupervisor();
    cubit = SettingsCubit(
      loadSettings: LoadSettings(repository),
      saveSettings: SaveSettings(repository),
      deleteUserData: DeleteUserData(repository),
      supervisor: supervisor,
      effects: [effect],
    );
  });

  tearDown(() async {
    await cubit.close();
    await supervisor.dispose();
  });

  test('load shows the saved settings and applies them', () async {
    repository.stored = const AppSettings(highContrast: true);

    await cubit.load();

    expect(cubit.state.status, SettingsStatus.ready);
    expect(cubit.state.settings.highContrast, isTrue);
    expect(effect.applied.last.highContrast, isTrue);
  });

  test('a failed load keeps the defaults and reports the problem', () async {
    repository.failLoad = true;
    final reports = <ErrorReport>[];
    supervisor.reports.listen(reports.add);

    await cubit.load();
    await pumpEventQueue();

    expect(cubit.state.status, SettingsStatus.ready);
    expect(cubit.state.settings, const AppSettings());
    expect(cubit.state.failure, isA<StorageFailure>());
    expect(reports, hasLength(1));
  });

  test('a change is shown, applied and saved', () async {
    await cubit.load();

    await cubit.toggleHighContrast();

    expect(cubit.state.settings.highContrast, isTrue);
    expect(effect.applied.last.highContrast, isTrue);
    expect(repository.stored.highContrast, isTrue);
  });

  test('a failed save brings the old value back', () async {
    await cubit.load();
    repository.failSave = true;

    await cubit.toggleHaptics();

    expect(cubit.state.settings.haptics, isTrue);
    expect(effect.applied.last.haptics, isTrue);
    expect(cubit.state.failure, isA<StorageFailure>());
  });

  test('the voice speed goes normal, fast, slow, normal', () async {
    await cubit.load();

    await cubit.cycleVoiceRate();
    expect(cubit.state.settings.voiceRate, VoiceRate.fast);
    await cubit.cycleVoiceRate();
    expect(cubit.state.settings.voiceRate, VoiceRate.slow);
    await cubit.cycleVoiceRate();
    expect(cubit.state.settings.voiceRate, VoiceRate.normal);
  });

  test('the text size goes through three steps and back', () async {
    await cubit.load();
    final first = cubit.state.settings.textScale;

    await cubit.cycleTextSize();
    final second = cubit.state.settings.textScale;
    await cubit.cycleTextSize();
    final third = cubit.state.settings.textScale;
    await cubit.cycleTextSize();

    expect(second, greaterThan(first));
    expect(third, greaterThan(second));
    expect(cubit.state.settings.textScale, first);
  });

  test('deleting removes the data and resets the settings', () async {
    repository.stored = const AppSettings(highContrast: true);
    await cubit.load();

    await cubit.deleteAllData();

    expect(repository.deletes, 1);
    expect(cubit.state.settings, const AppSettings());
    expect(cubit.state.justDeleted, isTrue);

    cubit.acknowledgeDeleted();
    expect(cubit.state.justDeleted, isFalse);
  });

  test('a failed delete keeps the settings and reports the problem', () async {
    repository.failDelete = true;
    await cubit.load();

    await cubit.deleteAllData();

    expect(cubit.state.justDeleted, isFalse);
    expect(cubit.state.failure, isA<StorageFailure>());
  });
}
