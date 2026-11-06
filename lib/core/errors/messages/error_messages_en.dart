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
