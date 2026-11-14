import 'package:go_router/go_router.dart';

GoRouterRedirect chainRedirects(List<GoRouterRedirect> redirects) {
  return (context, state) async {
    for (final redirect in redirects) {
      final target = await redirect(context, state);
      if (target != null) return target;
    }
    return null;
  };
}
