import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/permission_kind.dart';
import '../cubit/permissions_cubit.dart';
import '../cubit/permissions_state.dart';
import 'permission_prompt_view.dart';

class PermissionGate extends StatelessWidget {
  const PermissionGate({super.key, required this.kind, required this.child});

  final PermissionKind kind;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionsCubit, PermissionsState>(
      builder: (context, state) {
        if (!state.loaded) return const SizedBox.shrink();
        if (state.statusOf(kind).isGranted) return child;
        return PermissionPromptView(kind: kind);
      },
    );
  }
}
