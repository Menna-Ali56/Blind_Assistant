import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:baseer/core/errors/errors.dart';
import 'package:baseer/features/text_to_speech/data/data_sources/flutter_tts_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('flutter_tts');

  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late FlutterTtsDataSource dataSource;
  late List<MethodCall> calls;
  int speakResult = 1;

  setUp(() {
    calls = [];
    speakResult = 1;

    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);

      if (call.method == 'speak') {
        return speakResult;
      }

      return 1;
    });

    dataSource = FlutterTtsDataSource(FlutterTts());
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('initializes TTS and speaks the requested text', () async {
    await dataSource.speak('Hello Baseer', languageCode: 'en-US');

    expect(calls.any((call) => call.method == 'awaitSpeakCompletion'), isTrue);

    expect(calls.any((call) => call.method == 'setSpeechRate'), isTrue);

    expect(calls.any((call) => call.method == 'setVolume'), isTrue);

    expect(calls.any((call) => call.method == 'setPitch'), isTrue);

    expect(
      calls.any(
        (call) => call.method == 'setLanguage' && call.arguments == 'en-US',
      ),
      isTrue,
    );

    expect(
      calls.any(
        (call) => call.method == 'speak' && call.arguments == 'Hello Baseer',
      ),
      isTrue,
    );
  });

  test('does not initialize or speak empty text', () async {
    await dataSource.speak('   ', languageCode: 'en-US');

    expect(calls, isEmpty);
  });

  test('initializes only once', () async {
    await dataSource.speak('First message', languageCode: 'en-US');

    final initializationCalls = calls
        .where((call) => call.method == 'awaitSpeakCompletion')
        .length;

    await dataSource.speak('Second message', languageCode: 'en-US');

    expect(
      calls.where((call) => call.method == 'awaitSpeakCompletion').length,
      initializationCalls,
    );
  });

  test('throws SpeechException when playback fails', () async {
    speakResult = 0;

    await expectLater(
      dataSource.speak('Hello', languageCode: 'en-US'),
      throwsA(isA<SpeechException>()),
    );
  });

  test('stops TTS playback', () async {
    await dataSource.stop();

    expect(calls.any((call) => call.method == 'stop'), isTrue);
  });

  test('translates platform errors into SpeechException', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'awaitSpeakCompletion') {
        throw PlatformException(code: 'initialization_error');
      }

      return 1;
    });

    await expectLater(
      dataSource.speak('Hello', languageCode: 'en-US'),
      throwsA(isA<SpeechException>()),
    );
  });
}
