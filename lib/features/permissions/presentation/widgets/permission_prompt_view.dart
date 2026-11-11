import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/accessibility/semantics_extension.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../domain/entities/permission_kind.dart';
import '../cubit/permissions_cubit.dart';

class PermissionPromptView extends StatefulWidget {
  const PermissionPromptView({super.key, required this.kind, this.onSkip});

  final PermissionKind kind;
  final VoidCallback? onSkip;

  @override
  State<PermissionPromptView> createState() => _PermissionPromptViewState();
}

class _PermissionPromptViewState extends State<PermissionPromptView> {
  @override
  void initState() {
    super.initState();
    context.read<PermissionsCubit>().announce(widget.kind);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PermissionsCubit>();
    final texts = cubit.texts;
    final kind = widget.kind;
    final blocked = context.select(
      (PermissionsCubit c) => c.state.statusOf(kind).isBlocked,
    );
    final primaryLabel = blocked ? texts.settingsAction : texts.allowAction;
    final VoidCallback primary = blocked
        ? cubit.openSettings
        : () => cubit.request(kind);
    final onSkip = widget.onSkip;
    final theme = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: AppDimens.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              texts.label(kind),
              style: theme.headlineMedium,
              textAlign: TextAlign.center,
            ).asHeader(),
            const SizedBox(height: AppDimens.itemGap),
            Text(
              texts.purpose(kind),
              style: theme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.itemGap),
            FilledButton(
              onPressed: primary,
              child: Text(primaryLabel),
            ).asButton(label: primaryLabel, onTap: primary),
            if (onSkip != null) ...[
              const SizedBox(height: AppDimens.itemGap),
              OutlinedButton(
                onPressed: onSkip,
                child: Text(texts.notNowAction),
              ).asButton(label: texts.notNowAction, onTap: onSkip),
            ],
          ],
        ),
      ),
    );
  }
}
