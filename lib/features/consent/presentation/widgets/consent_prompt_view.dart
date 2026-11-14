import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/accessibility/semantics_extension.dart';
import '../../../../core/consent/consent_scope.dart';
import '../../../../core/constants/app_dimens.dart';
import '../cubit/consent_cubit.dart';

class ConsentPromptView extends StatefulWidget {
  const ConsentPromptView({super.key, required this.scope});

  final ConsentScope scope;

  @override
  State<ConsentPromptView> createState() => _ConsentPromptViewState();
}

class _ConsentPromptViewState extends State<ConsentPromptView> {
  @override
  void initState() {
    super.initState();
    context.read<ConsentCubit>().announce(widget.scope);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ConsentCubit>();
    final texts = cubit.texts;
    final scope = widget.scope;
    final theme = Theme.of(context).textTheme;
    void allow() => cubit.decide(scope, allowed: true);
    void deny() => cubit.decide(scope, allowed: false);
    return Center(
      child: SingleChildScrollView(
        padding: AppDimens.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              texts.label(scope),
              style: theme.headlineMedium,
              textAlign: TextAlign.center,
            ).asHeader(),
            const SizedBox(height: AppDimens.itemGap),
            Text(
              texts.purpose(scope),
              style: theme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.itemGap),
            FilledButton(
              onPressed: allow,
              child: Text(texts.allowAction),
            ).asButton(label: texts.allowAction, onTap: allow),
            const SizedBox(height: AppDimens.itemGap),
            OutlinedButton(
              onPressed: deny,
              child: Text(texts.notNowAction),
            ).asButton(label: texts.notNowAction, onTap: deny),
          ],
        ),
      ),
    );
  }
}
