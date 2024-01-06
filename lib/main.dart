import 'package:flutter/material.dart';
import 'package:online_classes_platform/core/services/dependency_injection/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

/// Widget representing the main application
class MyApp extends StatelessWidget {

  /// Constructor with optional 'key' parameter for MyApp.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Scaffold(),
    );
  }
}