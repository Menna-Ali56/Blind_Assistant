import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/features/settings/domain/entities/app_settings.dart';
import 'package:baseer/features/settings/domain/repositories/preferences_remote.dart';
import 'package:baseer/features/settings/presentation/effects/preferences_sync_effect.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePreferencesRemote implements PreferencesRemote {
  final List<AppSettings> saved = [];
  bool throwError = false;
  Failure? failure;

  @override
  Future<Result<void>> save(AppSettings settings) async {
    if (throwError) throw StateError('sync error');
    if (failure != null) return ResultFailure<void>(failure!);
    saved.add(settings);
    return const ResultSuccess<void>(null);
  }
}

void main() {
  test('NoPreferencesRemote returns success', () async {
    const remote = NoPreferencesRemote();

    expect(await remote.save(const AppSettings()), isA<ResultSuccess<void>>());
  });

  test(
    'PreferencesSyncEffect saves changes and deduplicates duplicates',
    () async {
      final remote = _FakePreferencesRemote();
      final effect = PreferencesSyncEffect(remote);
      const first = AppSettings(highContrast: true);
      const second = AppSettings(highContrast: true, voiceRate: VoiceRate.fast);

      effect.apply(first);
      effect.apply(first);
      effect.apply(second);
      await pumpEventQueue();

      expect(remote.saved, [first, second]);
    },
  );

  test('PreferencesSyncEffect absorbs remote throws and failures', () async {
    final remote = _FakePreferencesRemote()..throwError = true;
    final effect = PreferencesSyncEffect(remote);

    expect(() => effect.apply(const AppSettings()), returnsNormally);
    await pumpEventQueue();

    remote
      ..throwError = false
      ..failure = const NetworkFailure();
    expect(
      () => effect.apply(const AppSettings(haptics: false)),
      returnsNormally,
    );
    await pumpEventQueue();
    expect(remote.saved, isEmpty);
  });
}
