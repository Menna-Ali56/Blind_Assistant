import 'voice_assistant_texts.dart';
import 'voice_assistant_texts_ar.dart';
import 'voice_assistant_texts_en.dart';

VoiceAssistantTexts voiceAssistantTextsFor(String languageCode) =>
    languageCode.toLowerCase().startsWith('ar')
    ? arabicVoiceAssistantTexts
    : englishVoiceAssistantTexts;
