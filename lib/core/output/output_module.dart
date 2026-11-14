import 'package:get_it/get_it.dart';

import '../accessibility/screen_reader_status.dart';
import '../constants/app_languages.dart';
import '../di/di_module.dart';
import '../errors/errors.dart';
import 'announcement_channel.dart';
import 'audio_focus.dart';
import 'audio_session_focus.dart';
import 'error_output_bridge.dart';
import 'output_channel.dart';
import 'output_coordinator.dart';
import 'screen_reader_aware_channel.dart';

String defaultLanguageCode() => AppLanguages.arabic;

class OutputModule implements DiModule {
  const OutputModule({this.languageCode = defaultLanguageCode});

  final String Function() languageCode;

  @override
  void register(GetIt locator) {
    if (!locator.isRegistered<ScreenReaderStatus>()) {
      locator.registerLazySingleton<ScreenReaderStatus>(
        PlatformScreenReaderStatus.new,
      );
    }
    if (!locator.isRegistered<AudioFocus>()) {
      locator.registerLazySingleton<AudioFocus>(AudioSessionFocus.new);
    }
    if (!locator.isRegistered<OutputChannel>()) {
      locator.registerLazySingleton<OutputChannel>(() {
        const announcements = AnnouncementChannel();
        final OutputChannel speech = locator.isRegistered<SpeechChannel>()
            ? locator<SpeechChannel>()
            : announcements;
        return ScreenReaderAwareChannel(
          speech: speech,
          announcements: announcements,
          status: locator<ScreenReaderStatus>(),
        );
      });
    }
    locator
      ..registerLazySingleton<OutputCoordinator>(
        () => OutputCoordinator(
          locator<OutputChannel>(),
          focus: locator<AudioFocus>(),
        ),
        dispose: (coordinator) => coordinator.dispose(),
      )
      ..registerLazySingleton<ErrorOutputBridge>(
        () => ErrorOutputBridge(
          supervisor: locator<ErrorSupervisor>(),
          coordinator: locator<OutputCoordinator>(),
          languageCode: languageCode,
        ),
        dispose: (bridge) => bridge.stop(),
      );
  }
}
