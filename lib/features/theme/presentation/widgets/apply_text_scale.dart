import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_defaults.dart';
import '../cubit/theme_cubit.dart';

Widget applyTextScale(BuildContext context, Widget? child) {
  final extra = context.select((ThemeCubit cubit) => cubit.state.textScale);
  final media = MediaQuery.of(context);
  final system = media.textScaler.scale(AppDefaults.textScale);
  return MediaQuery(
    data: media.copyWith(textScaler: TextScaler.linear(system * extra)),
    child: child ?? const SizedBox.shrink(),
  );
}
