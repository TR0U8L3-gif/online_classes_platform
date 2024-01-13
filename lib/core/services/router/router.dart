import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_classes_platform/core/common/views/page_under_construction.dart';
import 'package:online_classes_platform/core/services/dependency_injection/injection_container.dart';
import 'package:online_classes_platform/core/utils/adapters/local_user_adapter.dart';
import 'package:online_classes_platform/core/utils/extension/context_extensions.dart';
import 'package:online_classes_platform/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:online_classes_platform/src/auth/presentation/pages/sign_in_screen.dart';
import 'package:online_classes_platform/src/auth/presentation/pages/sign_up_screen.dart';
import 'package:online_classes_platform/src/dashboard/presentation/pages/dashboard.dart';
import 'package:online_classes_platform/src/on_boarding/data/data_sources/on_boarding_local_data_source.dart';
import 'package:online_classes_platform/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:online_classes_platform/src/on_boarding/presentation/pages/on_boarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      final prefs = sl<SharedPreferences>();
      return _pageBuilder(
        (context) {
          if (prefs.getBool(kFirstTimerKey) ?? true) {
            return BlocProvider(
              create: (_) => sl<OnBoardingCubit>(),
              child: const OnBoardingScreen(),
            );
          } else if (sl<FirebaseAuth>().currentUser != null) {
            final user = sl<FirebaseAuth>().currentUser!;
            final localUser = LocalUserAdapter.fromFirebaseUser(user);
            context.userProvider.initUser(localUser);
            return const Dashboard();
          } else {
            return BlocProvider(
              create: (_) => sl<AuthBloc>(),
              child: const SignInScreen(),
            );
          }
        },
        settings: settings,
      );
    case SignInScreen.routeName:
      return _pageBuilder(
        (_) => const SignInScreen(),
        settings: settings,
      );
    case SignUpScreen.routeName:
      return _pageBuilder(
        (_) => const SignUpScreen(),
        settings: settings,
      );
    case OnBoardingScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<OnBoardingCubit>(),
          child: const OnBoardingScreen(),
        ),
        settings: settings,
      );
    default:
      return _pageBuilder(
        (_) => const PageUnderConstruction(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext context) page, {
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
