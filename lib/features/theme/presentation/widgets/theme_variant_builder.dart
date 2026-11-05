import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/theme_cubit.dart';
import '../cubit/theme_state.dart';

class ThemeVariantBuilder extends StatelessWidget {
  const ThemeVariantBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, ThemeVariant variant) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.variant != current.variant,
      builder: (context, state) => builder(context, state.variant),
    );
  }
}
