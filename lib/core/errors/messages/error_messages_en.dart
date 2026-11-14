import '../../constants/app_strings.dart';

const Map<String, String> englishErrorMessages = {
  'network_error':
      'No internet connection. Check your connection and try again.',
  'server_error': 'The server encountered a problem. Please try again.',
  'timeout_error': 'The request took too long. Please try again.',
  'camera_unavailable': 'The camera is currently unavailable.',
  'microphone_unavailable': 'The microphone is currently unavailable.',
  'storage_error': 'Something went wrong while saving data.',
  'model_error': 'The AI model could not complete the operation.',
  'ocr_error': 'Text could not be recognized from the image.',
  'speech_error': 'Something went wrong while processing speech.',
  'unexpected_error': 'An unexpected error occurred. Please try again.',
  'ocr_no_text':
      'No text found. Move the camera closer to the text and check the lighting.',
  'unauthorized': 'Your session has expired. Please sign in again.',
  'forbidden': 'You do not have permission to do this.',
  'not_found': 'The requested item was not found.',
  'too_many_requests': 'Too many requests. Wait a moment and try again.',
  'invalid_request': 'The request could not be sent. Please try again.',
  'image_too_large': 'The image is too large. Take a new photo.',
  'service_unavailable':
      'The service is unavailable right now. Please try again shortly.',
  'image_blurry':
      'The image is not clear. Hold the phone steady and take a new photo.',
  'image_too_dark':
      'The lighting is too low. Turn on the flash or move to a brighter place.',
  'image_unsupported': 'This image format is not supported. Take a new photo.',
  'intent_unknown':
      'I did not understand your request. Please say it another way.',
  'low_confidence':
      'I could not be sure of the result. Please try again more clearly.',
  'qr_not_found': 'I could not find a QR code. Move the camera slowly.',
  'qr_invalid': 'This QR code is not valid. Try another one.',
  'destination_not_found':
      'This destination is not registered. Choose another one.',
  'route_failed': 'The route could not be calculated. Please try again.',
  'action_retry': AppStrings.retryLabel,
  'action_new_capture': 'Start again',
  'action_sign_in': 'Sign in',
  'execution_offline': 'This feature needs an internet connection.',
  'execution_consent_missing':
      'I need your permission to send this to the server.',
  'execution_no_local_model':
      'This feature is not available offline right now.',
  'execution_low_confidence':
      'The result is not clear. Hold steady and try again.',
};

const Map<String, String> englishPermissionLabels = {
  'camera': 'camera',
  'microphone': 'microphone',
  'speech': 'speech recognition',
  'storage': 'storage',
  'location': 'location',
};
