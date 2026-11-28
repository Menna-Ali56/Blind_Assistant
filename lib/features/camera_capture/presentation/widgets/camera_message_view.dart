import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';

class CameraMessageView extends StatelessWidget {
  const CameraMessageView({
    super.key,
    required this.message,
    this.leading,
    this.trailing,
  });

  final String message;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final leading = this.leading;
    final trailing = this.trailing;
    return Center(
      child: SingleChildScrollView(
        padding: AppDimens.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (leading != null) ...[
              Center(child: leading),
              const SizedBox(height: AppDimens.itemGap),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (trailing != null) ...[
              const SizedBox(height: AppDimens.itemGap),
              trailing,
            ],
          ],
        ),
      ),
    );
  }
}
