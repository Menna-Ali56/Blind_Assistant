import 'package:get_it/get_it.dart';

import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../di/di_module.dart';
import '../output/audio_focus.dart';
import 'audioplayers_earcon_driver.dart';
import 'cue_output.dart';
import 'earcon_driver.dart';
import 'earcon_player.dart';
import 'feedback_coordinator.dart';
import 'haptic_driver.dart';
import 'haptic_player.dart';
import 'vibration_haptic_driver.dart';

bool _alwaysOn() => true;

class FeedbackModule implements DiModule {
  const FeedbackModule();

  @override
  void register(GetIt locator) {
    if (!locator.isRegistered<HapticDriver>()) {
      locator.registerLazySingleton<HapticDriver>(VibrationHapticDriver.new);
    }
    if (!locator.isRegistered<EarconDriver>()) {
      locator.registerLazySingleton<EarconDriver>(
        AudioplayersEarconDriver.new,
        dispose: (driver) => driver.dispose(),
      );
    }
    locator
      ..registerLazySingleton<HapticPlayer>(
        () => HapticPlayer(
          driver: locator<HapticDriver>(),
          isEnabled: () => locator<SettingsCubit>().state.settings.haptics,
        ),
      )
      ..registerLazySingleton<EarconPlayer>(
        () => EarconPlayer(
          driver: locator<EarconDriver>(),
          focus: locator<AudioFocus>(),
          isEnabled: _alwaysOn,
        ),
      )
      ..registerLazySingleton<FeedbackCoordinator>(
        () => FeedbackCoordinator([
          locator<HapticPlayer>(),
          locator<EarconPlayer>(),
        ]),
      )
      ..registerLazySingleton<CueOutput>(() => locator<FeedbackCoordinator>());
  }
}
