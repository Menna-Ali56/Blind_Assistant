import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injector.dart';

class InjectedCubit<C extends BlocBase<Object?>> extends StatelessWidget {
  const InjectedCubit({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<C>(create: (_) => sl<C>(), child: child);
  }
}
