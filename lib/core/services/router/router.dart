import 'package:flutter/material.dart';
import 'package:online_classes_platform/core/common/views/page_under_construction.dart';
import 'package:online_classes_platform/src/on_boarding/presentation/pages/on_boarding_screen.dart';
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OnBoardingScreen.routeName:
      return _pageBuilder((_) => const OnBoardingScreen(), settings: settings);
    default:
      return _pageBuilder((_) => const PageUnderConstruction(), settings: settings);
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    pageBuilder: (context, _, __) {
      return page(context);
    },
  );
}
