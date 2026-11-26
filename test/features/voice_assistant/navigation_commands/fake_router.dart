import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class FakeRouter extends Fake implements GoRouter {
  final List<String> visited = [];

  @override
  void go(String location, {Object? extra}) => visited.add(location);
}
