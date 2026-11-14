import 'package:go_router/go_router.dart';

import 'presentation/cubit/consent_cubit.dart';
import 'presentation/pages/consent_flow_page.dart';

const String consentPath = '/consent';

GoRoute consentRoute() => GoRoute(
  path: consentPath,
  builder: (context, state) => const ConsentFlowPage(),
);

GoRouterRedirect consentRedirect(
  ConsentCubit cubit, {
  Set<String> skipPaths = const {},
}) {
  return (context, state) async {
    final location = state.matchedLocation;
    if (location == consentPath || skipPaths.contains(location)) return null;
    return await cubit.needsFlow() ? consentPath : null;
  };
}
