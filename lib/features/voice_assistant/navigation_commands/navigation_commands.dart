import 'package:go_router/go_router.dart';

import '../../../core/output/output_module.dart';
import '../domain/entities/command_outcome.dart';
import '../domain/entities/voice_command.dart';
import '../domain/repositories/command_provider.dart';
import 'navigation_targets.dart';
import 'texts/navigation_texts_lookup.dart';

class NavigationCommands implements CommandProvider {
  NavigationCommands({
    required this._router,
    this._languageCode = defaultLanguageCode,
  });

  final GoRouter Function() _router;
  final String Function() _languageCode;

  @override
  late final List<VoiceCommand> commands = List.unmodifiable(
    navigationTargets.map(_commandFor),
  );

  VoiceCommand _commandFor(NavigationTarget target) => VoiceCommand(
    id: target.id,
    run: (slots) async {
      _router().go(target.path);
      final texts = navigationTextsFor(_languageCode());
      return CommandOutcome(
        spoken: texts.confirmation(target.screenName(texts)),
      );
    },
  );
}
