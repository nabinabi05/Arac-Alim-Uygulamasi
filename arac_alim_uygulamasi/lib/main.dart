// lib/main.dart
import 'package:flutter/material.dart';
import 'theme.dart';
import 'constants.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(AracAlimApp());
}

class AracAlimApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      theme: AppTheme.lightTheme,
      home: HomeScreen(),
    );
  }
}
