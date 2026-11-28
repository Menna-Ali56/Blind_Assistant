import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/accessibility/semantics_extension.dart';
import '../../../../core/constants/app_dimens.dart';
import '../cubit/quality_flow_state.dart';
import '../cubit/quality_gate_cubit.dart';
import '../texts/quality_texts_lookup.dart';

class QualityRetakeButton extends StatelessWidget {
  const QualityRetakeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;
    final texts = qualityTextsFor(language);
    return BlocBuilder<QualityGateCubit, QualityFlowState>(
      buildWhen: (before, after) => before.canRetake != after.canRetake,
      builder: (context, state) {
        if (!state.canRetake) return const SizedBox.shrink();
        final cubit = context.read<QualityGateCubit>();
        return SizedBox(
          width: double.infinity,
          height: AppDimens.buttonHeight,
          child:
              FilledButton(
                onPressed: cubit.retake,
                child: Text(texts.retakeLabel),
              ).asButton(
                label: texts.retakeLabel,
                hint: texts.retakeHint,
                onTap: cubit.retake,
              ),
        );
      },
    );
  }
}
