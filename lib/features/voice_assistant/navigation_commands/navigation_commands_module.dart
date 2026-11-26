import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/di_module.dart';
import '../../../core/output/output_module.dart';
import '../domain/repositories/command_registry.dart';
import 'navigation_commands.dart';

class NavigationCommandsModule implements DiModule {
  const NavigationCommandsModule({this.languageCode = defaultLanguageCode});

  final String Function() languageCode;

  @override
  void register(GetIt locator) {
    locator<CommandRegistry>().add(
      NavigationCommands(
        router: () => locator<GoRouter>(),
        languageCode: languageCode,
      ),
    );
  }
}
