import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';

/// Text never gets smaller than the system size and stops at two times
Widget appTextScaleBuilder(BuildContext context, Widget? child) {
  return MediaQuery.withClampedTextScaling(
    minScaleFactor: AppDimens.minTextScale,
    maxScaleFactor: AppDimens.maxTextScale,
    child: child ?? const SizedBox.shrink(),
  );
}
