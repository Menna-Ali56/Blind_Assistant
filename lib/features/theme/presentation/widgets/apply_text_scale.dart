import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/accessibility/text_scale.dart';
import '../../../../core/constants/app_defaults.dart';
import '../cubit/theme_cubit.dart';

Widget applyTextScale(BuildContext context, Widget? child) {
  final extra = context.select((ThemeCubit cubit) => cubit.state.textScale);
  final media = MediaQuery.of(context);
  final system = media.textScaler.scale(AppDefaults.textScale);
  final total = effectiveTextScale(system: system, extra: extra);
  return MediaQuery(
    data: media.copyWith(textScaler: TextScaler.linear(total)),
    child: child ?? const SizedBox.shrink(),
  );
}
