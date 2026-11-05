import 'package:flutter/material.dart';

import '../accessibility/semantics_extension.dart';
import '../constants/app_dimens.dart';
import '../constants/app_strings.dart';
import '../errors/presentation/error_presentation.dart';

class ErrorRetryView extends StatelessWidget {
  const ErrorRetryView({super.key, required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final presentation = ErrorPresentation.from(
      error,
      languageCode: Localizations.localeOf(context).languageCode,
    );
    if (presentation.isSilent) return const SizedBox.shrink();
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
            if (presentation.canRetry) ...[
              const SizedBox(height: AppDimens.itemGap),
              FilledButton(
                onPressed: onRetry,
                child: const Text(AppStrings.retryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
