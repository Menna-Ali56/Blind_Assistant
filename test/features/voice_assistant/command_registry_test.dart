import 'package:baseer/features/voice_assistant/voice_assistant.dart';
import 'package:flutter_test/flutter_test.dart';

import 'voice_assistant_test_support.dart';

void main() {
  late CommandRegistry registry;

  setUp(() => registry = CommandRegistry());

  test('finds added commands and lists their ids', () {
    registry.add(FakeProvider([fakeCommand('a'), fakeCommand('b')]));

    expect(registry.find('a')?.id, 'a');
    expect(registry.ids, ['a', 'b']);
    expect(registry.find('missing'), isNull);
  });

  test('a repeated id across providers throws', () {
    registry.add(FakeProvider([fakeCommand('a')]));

    expect(
      () => registry.add(FakeProvider([fakeCommand('a')])),
      throwsArgumentError,
    );
  });

  test('a repeated id inside one provider throws and adds nothing', () {
    final provider = FakeProvider([fakeCommand('a'), fakeCommand('a')]);

    expect(() => registry.add(provider), throwsArgumentError);
    expect(registry.ids, isEmpty);
  });
}
