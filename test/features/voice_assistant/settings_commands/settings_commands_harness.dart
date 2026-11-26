import 'package:baseer/core/constants/app_languages.dart';
import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/features/settings/domain/usecases/delete_user_data.dart';
import 'package:baseer/features/settings/domain/usecases/load_settings.dart';
import 'package:baseer/features/settings/domain/usecases/save_settings.dart';
import 'package:baseer/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:baseer/features/voice_assistant/domain/entities/voice_command.dart';
import 'package:baseer/features/voice_assistant/settings_commands/settings_commands.dart';

import '../../settings/settings_cubit_test.dart' show FakeRepository;

class SettingsCommandsHarness {
  SettingsCommandsHarness({String language = AppLanguages.english}) {
    cubit = SettingsCubit(
      loadSettings: LoadSettings(repository),
      saveSettings: SaveSettings(repository),
      deleteUserData: DeleteUserData(repository),
      supervisor: supervisor,
    );
    commands = SettingsCommands(
      cubit: () => cubit,
      languageCode: () => language,
    ).commands;
  }

  final FakeRepository repository = FakeRepository();
  final ErrorSupervisor supervisor = ErrorSupervisor();
  late final SettingsCubit cubit;
  late final List<VoiceCommand> commands;

  Future<String?> run(String id, [Map<String, String> slots = const {}]) async {
    final command = commands.firstWhere((c) => c.id == id);
    return (await command.run(slots)).spoken;
  }

  Future<void> dispose() async {
    await cubit.close();
    await supervisor.dispose();
  }
}
