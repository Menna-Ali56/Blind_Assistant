import 'package:baseer/features/text_to_speech/data/channels/tts_speech_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:baseer/core/output/output.dart';
import 'package:baseer/features/text_to_speech/data/data_sources/flutter_tts_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const ttsChannel = MethodChannel('flutter_tts');

  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late List<MethodCall> calls;
  late TtsSpeechChannel speechChannel;

  setUp(() {
    calls = [];

    messenger.setMockMethodCallHandler(ttsChannel, (call) async {
      calls.add(call);
      return 1;
    });

    speechChannel = TtsSpeechChannel(FlutterTtsDataSource(FlutterTts()));
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(ttsChannel, null);
  });

  test('forwards speech to Flutter TTS', () async {
    await speechChannel.speak(
      'Welcome to Baseer',
      languageCode: 'en-US',
      priority: OutputPriority.values.first,
    );

    expect(
      calls.any(
        (call) => call.method == 'setLanguage' && call.arguments == 'en-US',
      ),
      isTrue,
    );

    expect(calls.any((call) => call.method == 'speak'), isTrue);
  });

  test('forwards stop to Flutter TTS', () async {
    await speechChannel.stop();

    expect(calls.any((call) => call.method == 'stop'), isTrue);
  });

  test('does nothing for no haptic feedback', () async {
    await speechChannel.haptic(OutputHaptic.none);

    expect(calls, isEmpty);
  });
}
