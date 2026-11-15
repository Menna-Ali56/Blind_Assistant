import 'package:baseer/core/accessibility/screen_reader_status.dart';
import 'package:baseer/core/output/output.dart';
import 'package:flutter_test/flutter_test.dart';

import 'output_test_support.dart';

class _FakeScreenReaderStatus implements ScreenReaderStatus {
  @override
  bool isActive = false;
}

void main() {
  late RecordingOutputChannel speech;
  late RecordingOutputChannel announcements;
  late _FakeScreenReaderStatus status;
  late ScreenReaderAwareChannel channel;

  setUp(() {
    speech = RecordingOutputChannel();
    announcements = RecordingOutputChannel();
    status = _FakeScreenReaderStatus();
    channel = ScreenReaderAwareChannel(
      speech: speech,
      announcements: announcements,
      status: status,
    );
  });

  test('active + normal goes to announcements', () async {
    status.isActive = true;
    await channel.speak(
      'hello',
      languageCode: 'en',
      priority: OutputPriority.normal,
    );
    expect(announcements.spoken, ['hello']);
    expect(speech.spoken, isEmpty);
  });

  test('active + high goes to speech', () async {
    status.isActive = true;
    await channel.speak(
      'urgent',
      languageCode: 'en',
      priority: OutputPriority.high,
    );
    expect(speech.spoken, ['urgent']);
    expect(announcements.spoken, isEmpty);
  });

  test('inactive + normal goes to speech', () async {
    status.isActive = false;
    await channel.speak(
      'hello',
      languageCode: 'en',
      priority: OutputPriority.normal,
    );
    expect(speech.spoken, ['hello']);
    expect(announcements.spoken, isEmpty);
  });

  test('stop stops both channels', () async {
    await channel.stop();
    expect(speech.stops, 1);
    expect(announcements.stops, 1);
  });
}
