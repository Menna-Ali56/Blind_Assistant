import 'package:go_router/go_router.dart';

import 'presentation/cubit/permissions_cubit.dart';
import 'presentation/pages/permission_flow_page.dart';

const String permissionsPath = '/permissions';

GoRoute permissionsRoute() => GoRoute(
  path: permissionsPath,
  builder: (context, state) => const PermissionFlowPage(),
);

GoRouterRedirect permissionsRedirect(PermissionsCubit cubit) {
  return (context, state) async {
    if (state.matchedLocation == permissionsPath) return null;
    return await cubit.needsFlow() ? permissionsPath : null;
  };
}
