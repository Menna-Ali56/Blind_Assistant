import 'package:flutter/material.dart';

import '../accessibility/semantics_extension.dart';
import '../constants/app_dimens.dart';
import '../errors/failures/retry_hint.dart';
import '../errors/presentation/error_presentation.dart';

class ErrorRetryView extends StatelessWidget {
  const ErrorRetryView({
    super.key,
    required this.error,
    required this.onRetry,
    this.onSignIn,
    this.canRetryAgain = true,
  });

  final Object error;
  final VoidCallback onRetry;
  final VoidCallback? onSignIn;
  final bool canRetryAgain;

  @override
  Widget build(BuildContext context) {
    final presentation = ErrorPresentation.from(
      error,
      languageCode: Localizations.localeOf(context).languageCode,
    );
    if (presentation.isSilent) return const SizedBox.shrink();
    final action = _actionFor(presentation.retryHint);
    final label = presentation.actionLabel;
    return Center(
      child: Padding(
        padding: AppDimens.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              presentation.message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ).asLiveRegion(),
            if (action != null && label != null) ...[
              const SizedBox(height: AppDimens.itemGap),
              FilledButton(onPressed: action, child: Text(label)),
            ],
          ],
        ),
      ),
    );
  }

  VoidCallback? _actionFor(RetryHint hint) => switch (hint) {
    RetryHint.none => null,
    RetryHint.login => onSignIn,
    RetryHint.newCapture => onRetry,
    RetryHint.sameRequest => canRetryAgain ? onRetry : null,
  };
}
