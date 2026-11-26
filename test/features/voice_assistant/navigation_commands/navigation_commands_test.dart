import 'package:baseer/core/constants/app_languages.dart';
import 'package:baseer/core/navigation/app_destination.dart';
import 'package:baseer/features/settings/settings_route.dart';
import 'package:baseer/features/voice_assistant/navigation_commands.dart';
import 'package:baseer/features/voice_assistant/navigation_commands/texts/navigation_texts_lookup.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_router.dart';

final String _settingsId = openCommandId(settingsCommandName);

final Map<String, String> _paths = {
  for (final item in AppDestination.values) openCommandId(item.name): item.path,
  _settingsId: settingsPath,
};

Map<String, String> _names(String language) {
  final texts = navigationTextsFor(language);
  return {
    for (final item in AppDestination.values)
      openCommandId(item.name): texts.screenName(item),
    _settingsId: texts.settings,
  };
}

NavigationCommands _build(FakeRouter router, [String? language]) =>
    NavigationCommands(
      router: () => router,
      languageCode: () => language ?? AppLanguages.english,
    );

void main() {
  test('every destination and settings has one command', () {
    final ids = _build(FakeRouter()).commands.map((c) => c.id).toList();
    expect(ids.toSet(), _paths.keys.toSet());
    expect(ids, hasLength(_paths.length));
  });

  test('ids follow the open prefix and the enum name', () {
    expect(openCommandId(AppDestination.read.name), 'open.read');
    expect(_settingsId, 'open.settings');
  });

  test('the router is read only when a command runs', () async {
    var reads = 0;
    final router = FakeRouter();
    final commands = NavigationCommands(
      router: () {
        reads++;
        return router;
      },
    ).commands;
    expect(reads, 0);
    await commands.first.run(const {});
    expect(reads, 1);
  });

  for (final language in [AppLanguages.arabic, AppLanguages.english]) {
    test('commands go to the right path and speak in $language', () async {
      final router = FakeRouter();
      final names = _names(language);
      for (final command in _build(router, language).commands) {
        router.visited.clear();
        final outcome = await command.run(const {});
        expect(router.visited, [_paths[command.id]]);
        expect(outcome.spoken, contains(names[command.id]));
      }
    });
  }
}
