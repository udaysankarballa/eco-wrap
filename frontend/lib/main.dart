import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const EcoWrapApp());
}

class EcoWrapApp extends StatelessWidget {
  const EcoWrapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ECO WRAP',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
