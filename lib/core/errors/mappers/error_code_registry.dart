import '../failures/retry_hint.dart';

class ErrorRule {
  const ErrorRule(this.messageKey, this.retry);

  final String messageKey;
  final RetryHint retry;
}

const _same = RetryHint.sameRequest;
const _fresh = RetryHint.newCapture;
const _login = RetryHint.login;
const _none = RetryHint.none;

abstract final class ErrorCodeRegistry {
  static const String fileTooLarge = 'ERR_FILE_TOO_LARGE';
  static const String unknownMessageKey = 'unexpected_error';

  static const Map<String, ErrorRule> rules = {
    'ERR_INTERNAL_SERVER_ERROR': ErrorRule('server_error', _same),
    'ERR_VALIDATION_FAILED': ErrorRule('invalid_request', _none),
    'ERR_BAD_REQUEST': ErrorRule('invalid_request', _none),
    'ERR_UNAUTHORIZED': ErrorRule('unauthorized', _login),
    'ERR_FORBIDDEN': ErrorRule('forbidden', _none),
    'ERR_NOT_FOUND': ErrorRule('not_found', _none),
    fileTooLarge: ErrorRule('image_too_large', _fresh),
    'ERR_TOO_MANY_REQUESTS': ErrorRule('too_many_requests', _same),
    'ERR_SERVICE_UNAVAILABLE': ErrorRule('service_unavailable', _same),
    'ERR_REQUEST_TIMEOUT': ErrorRule('timeout_error', _same),
    'ERR_IMAGE_BLURRY': ErrorRule('image_blurry', _fresh),
    'ERR_IMAGE_TOO_DARK': ErrorRule('image_too_dark', _fresh),
    'ERR_NO_TEXT_DETECTED': ErrorRule('ocr_no_text', _fresh),
    'ERR_UNSUPPORTED_IMAGE_FORMAT': ErrorRule('image_unsupported', _fresh),
    'ERR_INTENT_NOT_RECOGNIZED': ErrorRule('intent_unknown', _fresh),
    'ERR_LOW_CONFIDENCE': ErrorRule('low_confidence', _fresh),
    'ERR_QR_NOT_FOUND': ErrorRule('qr_not_found', _fresh),
    'ERR_INVALID_QR_CODE': ErrorRule('qr_invalid', _fresh),
    'ERR_DESTINATION_NOT_FOUND': ErrorRule('destination_not_found', _none),
    'ERR_ROUTE_CALCULATION_FAILED': ErrorRule('route_failed', _same),
  };

  static const ErrorRule unknown = ErrorRule(unknownMessageKey, _same);

  static ErrorRule ruleFor(String code) => rules[code] ?? unknown;
}
