import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_destination.dart';
import '../../../../core/widgets/screen_scaffold.dart';
import '../cubit/permissions_cubit.dart';
import '../cubit/permissions_state.dart';
import '../widgets/permission_prompt_view.dart';

class PermissionFlowPage extends StatelessWidget {
  const PermissionFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PermissionsCubit>();
    return BlocConsumer<PermissionsCubit, PermissionsState>(
      listenWhen: (previous, current) =>
          !previous.isComplete && current.isComplete,
      listener: (context, state) {
        cubit.finish();
        context.go(AppDestination.initial.path);
      },
      builder: (context, state) {
        final kind = state.pending;
        return ScreenScaffold(
          title: cubit.texts.title,
          child: kind == null
              ? const SizedBox.shrink()
              : PermissionPromptView(
                  key: ValueKey(kind),
                  kind: kind,
                  onSkip: () => cubit.skip(kind),
                ),
        );
      },
    );
  }
}
