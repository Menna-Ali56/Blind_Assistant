import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../constants/app_languages.dart';
import '../errors/failures/unknown_failure.dart';
import '../errors/messages/error_message_mapper.dart';

class SafeErrorView extends StatelessWidget {
  const SafeErrorView({super.key, this.languageCode});

  final String? languageCode;

  @override
  Widget build(BuildContext context) {
    final code =
        languageCode ??
        Localizations.maybeLocaleOf(context)?.languageCode ??
        AppLanguages.arabic;
    final message = const ErrorMessageMapper().map(
      const UnknownFailure(),
      languageCode: code,
    );
    final isArabic = code.toLowerCase().startsWith(AppLanguages.arabic);
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Center(
        child: Padding(
          padding: AppDimens.pagePadding,
          child: Semantics(
            liveRegion: true,
            label: message,
            child: Text(message, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
