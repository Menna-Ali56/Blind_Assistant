import 'package:get_it/get_it.dart';

import '../../../core/di/di_module.dart';
import '../../../core/output/output_module.dart';
import '../../settings/presentation/cubit/settings_cubit.dart';
import '../domain/repositories/command_registry.dart';
import 'settings_commands_provider.dart';

class SettingsCommandsModule implements DiModule {
  const SettingsCommandsModule({this.languageCode = defaultLanguageCode});

  final String Function() languageCode;

  @override
  void register(GetIt locator) {
    locator<CommandRegistry>().add(
      SettingsCommands(
        cubit: () => locator<SettingsCubit>(),
        languageCode: languageCode,
      ),
    );
  }
}
