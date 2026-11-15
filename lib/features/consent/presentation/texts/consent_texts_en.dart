import '../../../../core/consent/consent_scope.dart';
import 'consent_texts.dart';

const ConsentTexts englishConsentTexts = ConsentTexts(
  labels: {
    ConsentScope.imageUpload: 'Send photos to cloud',
    ConsentScope.audioUpload: 'Send audio to cloud',
    ConsentScope.locationShare: 'Share location for navigation',
  },
  purposes: {
    ConsentScope.imageUpload:
        'Allows Baseer to upload photos when needed to read documents, '
        'describe scenes, or answer visual questions.',
    ConsentScope.audioUpload:
        'Allows Baseer to upload audio for richer voice questions and '
        'conversations.',
    ConsentScope.locationShare:
        'Allows Baseer to share your location during navigation to guide '
        'your route.',
  },
  title: 'Privacy consent',
  allowAction: 'Allow',
  notNowAction: 'Not now',
  allowHint: 'Tap Allow or Not now to continue.',
  doneMessage: 'Privacy preferences saved.',
);
