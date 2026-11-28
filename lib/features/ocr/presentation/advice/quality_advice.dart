import '../../../../core/errors/failures/api_failure.dart';
import '../../../../core/errors/messages/error_message_mapper.dart';
import '../../domain/quality/quality_issue.dart';
import '../texts/quality_texts.dart';
import '../texts/quality_texts_lookup.dart';

class QualityAdvice {
  const QualityAdvice({this.messages = const ErrorMessageMapper()});

  static const String _separator = ' ';
  static const Map<QualityIssue, String> _errorCodes = {
    QualityIssue.blurry: 'ERR_IMAGE_BLURRY',
    QualityIssue.tooDark: 'ERR_IMAGE_TOO_DARK',
    QualityIssue.unreadable: 'ERR_UNSUPPORTED_IMAGE_FORMAT',
  };

  final ErrorMessageMapper messages;

  ApiFailure? failureFor(QualityIssue issue) {
    final code = _errorCodes[issue];
    return code == null ? null : ApiFailure.fromCode(code);
  }

  String spokenFor(QualityIssue issue, {required String languageCode}) {
    final texts = qualityTextsFor(languageCode);
    final parts = [
      _base(issue, texts, languageCode),
      _tip(issue, texts),
      texts.retake,
    ];
    return parts.whereType<String>().join(_separator);
  }

  String _base(QualityIssue issue, QualityTexts texts, String languageCode) {
    final failure = failureFor(issue);
    if (failure == null) return texts.tooBright;
    return messages.map(failure, languageCode: languageCode);
  }

  String? _tip(QualityIssue issue, QualityTexts texts) =>
      issue == QualityIssue.blurry ? texts.moveCloser : null;
}
