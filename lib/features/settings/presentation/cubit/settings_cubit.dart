
import '../../../../core/cubit/base_cubit.dart';
import '../../../../core/errors/errors.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/delete_user_data.dart';
import '../../domain/usecases/load_settings.dart';
import '../../domain/usecases/save_settings.dart';
import '../effects/settings_effect.dart';
import 'settings_state.dart';
import 'text_size_step.dart';

class SettingsCubit extends BaseCubit<SettingsState> {
  SettingsCubit({
    required LoadSettings loadSettings,
    required SaveSettings saveSettings,
    required DeleteUserData deleteUserData,
    required ErrorSupervisor supervisor,
    Iterable<SettingsEffect> effects = const [],
  }) : _load = loadSettings,
        _save = saveSettings,
        _delete = deleteUserData,
        _supervisor = supervisor,
        _effects = List.of(effects),
        super(const SettingsState());


  static const String _source = 'settings';

  final LoadSettings _load;
  final SaveSettings _save;
  final DeleteUserData _delete;
  final ErrorSupervisor _supervisor;
  final List<SettingsEffect> _effects;

  
  Future<void> load() async {
    safeEmit(state.copyWith(status: SettingsStatus.loading));
    final result = await _load();

    var settings = const AppSettings();
    Failure? failure;

    result.fold(
      onSuccess: (loaded) => settings = loaded,
      onFailure: (error) => failure = error,
    );

    _applyEffects(settings);

    final loadFailure = failure;
    if (loadFailure != null) {
      _supervisor.reportFailure(loadFailure, source: _source);
    }

    safeEmit(
      SettingsState(
        status: SettingsStatus.ready,
        settings: settings,
        failure: loadFailure,
      ),
    );
  }

  Future<void> cycleVoiceRate() => _update(
        (s) => s.copyWith(
      voiceRate: VoiceRate.values[
      (s.voiceRate.index + 1) % VoiceRate.values.length
      ],
    ),
  );

  Future<void> cycleTextSize() => _update(
        (s) => s.copyWith(
      textScale: TextSizeStep.fromScale(s.textScale).next.scale,
    ),
  );

  Future<void> toggleHighContrast() =>
      _update((s) => s.copyWith(highContrast: !s.highContrast));

  Future<void> toggleHaptics() =>
      _update((s) => s.copyWith(haptics: !s.haptics));

  Future<void> toggleWakeWord() =>
      _update((s) => s.copyWith(wakeWord: !s.wakeWord));

  Future<void> toggleImageUpload() =>
      _update((s) => s.copyWith(allowImageUpload: !s.allowImageUpload));

  /// Removes everything stored on the device and goes back to the defaults.
  Future<void> deleteAllData() async {
    final result = await _delete();

    result.fold(
      onSuccess: (_) {
        const defaults = AppSettings();
        _applyEffects(defaults);

        safeEmit(
          state.copyWith(
            settings: defaults,
            justDeleted: true,
            clearFailure: true,
          ),
        );
      },
      onFailure: (failure) {
        _supervisor.reportFailure(failure, source: _source);
        safeEmit(state.copyWith(failure: failure));
      },
    );
  }

  void acknowledgeDeleted() =>
      safeEmit(state.copyWith(justDeleted: false));

  /// Changes the screen at once, then saves.
  /// If saving fails the old value comes back and the problem is reported.
  Future<void> _update(
      AppSettings Function(AppSettings current) change,
      ) async {
    final previous = state.settings;
    final next = change(previous);

    if (next == previous) return;

    _applyEffects(next);
    safeEmit(state.copyWith(settings: next, clearFailure: true));

    final result = await _save(next);

    result.fold(
      onSuccess: (_) {},
      onFailure: (failure) {
        _supervisor.reportFailure(failure, source: _source);

        if (state.settings != next) return;

        _applyEffects(previous);
        safeEmit(state.copyWith(settings: previous, failure: failure));
      },
    );
  }

  void _applyEffects(AppSettings settings) {
    for (final effect in _effects) {
      effect.apply(settings);
    }
  }
}
