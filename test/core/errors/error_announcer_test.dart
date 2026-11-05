import 'package:baseer/core/errors/errors.dart';
import 'package:flutter_test/flutter_test.dart';

class _FixedMessages extends ErrorMessageMapper {
  const _FixedMessages();

  @override
  String map(Failure failure, {required String languageCode}) => 'custom';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('speaks the message from the given mapper', () async {
    final spoken = <String>[];
    final announcer = ErrorAnnouncer(
      speak: (text) async => spoken.add(text),
      mapper: const _FixedMessages(),
    );
    await announcer.announce(const NetworkFailure(), languageCode: 'en');
    expect(spoken, ['custom']);
  });
}
