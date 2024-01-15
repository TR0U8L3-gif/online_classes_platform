import 'package:flutter/material.dart';
import 'package:online_classes_platform/core/common/providers/user_provider.dart';
import 'package:online_classes_platform/core/helpers/tab_navigator.dart';
import 'package:online_classes_platform/src/auth/domain/entities/local_user.dart';
import 'package:provider/provider.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;

  double get height => size.height;

  double get width => size.width;

  UserProvider get userProvider => read<UserProvider>();

  LocalUser? get currentUser => userProvider.user;

  TabNavigator get tabNavigator => read<TabNavigator>();

  void pop() => tabNavigator.pop();

  TabItem push(Widget page) => tabNavigator.push(page);
}
