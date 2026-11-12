import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/permissions_cubit.dart';

class PermissionStatusSync extends StatefulWidget {
  const PermissionStatusSync({super.key, required this.child});

  final Widget child;

  @override
  State<PermissionStatusSync> createState() => _PermissionStatusSyncState();
}

class _PermissionStatusSyncState extends State<PermissionStatusSync>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  void _refresh() => context.read<PermissionsCubit>().refresh();

  @override
  Widget build(BuildContext context) => widget.child;
}
