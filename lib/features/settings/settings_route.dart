import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injector.dart';
import 'presentation/cubit/settings_cubit.dart';
import 'presentation/pages/settings_page.dart';

const String settingsPath = '/settings';


GoRoute settingsRoute() => GoRoute(
  path: settingsPath,
  builder: (context, state) => BlocProvider<SettingsCubit>.value(
    value: sl<SettingsCubit>()..load(),
    child: const SettingsPage(),
  ),
);
