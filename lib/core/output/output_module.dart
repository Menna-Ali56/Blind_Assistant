import 'package:get_it/get_it.dart';

import '../di/di_module.dart';
import '../errors/errors.dart';
import 'error_output_bridge.dart';
import 'output_channel.dart';
import 'output_coordinator.dart';

String defaultLanguageCode() => 'ar';

class OutputModule implements DiModule {
  const OutputModule({this.languageCode = defaultLanguageCode});

  final String Function() languageCode;

  @override
  void register(GetIt locator) {
    // The text to speech module registers the real channel before this one.
    if (!locator.isRegistered<OutputChannel>()) {
      locator.registerLazySingleton<OutputChannel>(SilentOutputChannel.new);
    }
    locator
      ..registerLazySingleton<OutputCoordinator>(
        () => OutputCoordinator(locator<OutputChannel>()),
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
