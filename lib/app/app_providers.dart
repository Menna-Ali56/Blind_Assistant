import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injector.dart';
import '../features/consent/consent.dart';
import '../features/permissions/permissions.dart';
import '../features/theme/presentation/cubit/theme_cubit.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: sl<ThemeCubit>()),
        BlocProvider<PermissionsCubit>.value(value: sl<PermissionsCubit>()),
        BlocProvider<ConsentCubit>.value(value: sl<ConsentCubit>()),
      ],
      child: PermissionStatusSync(child: child),
    );
  }
}
