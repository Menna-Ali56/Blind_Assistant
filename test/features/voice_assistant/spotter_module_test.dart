import 'package:baseer/core/di/injector.dart';
import 'package:baseer/features/voice_assistant/spotter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'support/fake_keyword_spotter.dart';
import 'support/recording_command_sink.dart';

void main() {
  test('one shared controller is registered', () async {
    final locator = GetIt.asNewInstance()
      ..registerLazySingleton<KeywordSpotter>(FakeKeywordSpotter.new)
      ..registerLazySingleton<CommandSink>(RecordingCommandSink.new);
    configureDependencies(const [SpotterModule()], locator: locator);

    expect(locator<SpotterController>(), same(locator<SpotterController>()));
    await locator.reset();
  });
}
