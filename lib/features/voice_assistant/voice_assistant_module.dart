import 'package:get_it/get_it.dart';

import '../../core/di/di_module.dart';
import '../../core/errors/errors.dart';
import '../../core/output/output.dart';
import 'domain/repositories/command_registry.dart';
import 'domain/repositories/command_router.dart';
import 'domain/repositories/command_sink.dart';

class VoiceAssistantModule implements DiModule {
  const VoiceAssistantModule({this.languageCode = defaultLanguageCode});

  final String Function() languageCode;

  @override
  void register(GetIt locator) {
    locator
      ..registerLazySingleton<CommandRegistry>(CommandRegistry.new)
      ..registerLazySingleton<CommandSink>(
        () => CommandRouter(
          registry: locator<CommandRegistry>(),
          output: locator<OutputCoordinator>(),
          supervisor: locator<ErrorSupervisor>(),
          languageCode: languageCode,
        ),
      );
  }
}
