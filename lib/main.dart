import 'package:flutter/material.dart';
import 'package:online_classes_platform/core/assets/app_colors.dart';
import 'package:online_classes_platform/core/assets/fonts.dart';

import 'package:online_classes_platform/core/services/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// Widget representing the main application
class MyApp extends StatelessWidget {

  /// Constructor with optional 'key' parameter for MyApp.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Classes Platform',
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: Fonts.poppins,
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
        ),
        colorScheme:  ColorScheme.fromSwatch(accentColor: AppColors.primaryColor),
      ),
      onGenerateRoute: generateRoute,
    );
  }
}