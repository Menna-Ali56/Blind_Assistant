import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_destination.dart';
import '../../../../core/widgets/screen_scaffold.dart';
import '../cubit/consent_cubit.dart';
import '../cubit/consent_state.dart';
import '../widgets/consent_prompt_view.dart';

class ConsentFlowPage extends StatelessWidget {
  const ConsentFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ConsentCubit>();
    return BlocConsumer<ConsentCubit, ConsentState>(
      listenWhen: (previous, current) =>
          !previous.isComplete && current.isComplete,
      listener: (context, state) {
        cubit.finish();
        context.go(AppDestination.initial.path);
      },
      builder: (context, state) {
        final scope = state.pending;
        return ScreenScaffold(
          title: cubit.texts.title,
          child: scope == null
              ? const SizedBox.shrink()
              : ConsentPromptView(key: ValueKey(scope), scope: scope),
        );
      },
    );
  }
}
