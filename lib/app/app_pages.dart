import 'package:flutter/widgets.dart';

import '../core/navigation/app_destination.dart';
import '../core/widgets/placeholder_page.dart';
import '../features/home/presentation/pages/home_page.dart';

Widget appPage(AppDestination destination) {
  return switch (destination) {
    AppDestination.home => const HomePage(),
    _ => PlaceholderPage(destination: destination),
  };
}
