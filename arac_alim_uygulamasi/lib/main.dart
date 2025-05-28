<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AracAlimApp());
}

class AracAlimApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreenWrapper(),
    );
  }
}

class HomeScreenWrapper extends StatefulWidget {
  @override
  _HomeScreenWrapperState createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends State<HomeScreenWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
=======
// lib/main.dart
import 'package:flutter/material.dart';
import 'ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isDark = await StorageService.getTheme();
  final lang   = await StorageService.getLanguage();
  runApp(MyApp(isDarkMode: isDark, languageCode: lang));
}

class AracAlimApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreenWrapper(),
    );
  }
}

class HomeScreenWrapper extends StatefulWidget {
  @override
  _HomeScreenWrapperState createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends State<HomeScreenWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
>>>>>>> cd0c4c2309ce03a59a877c8989efdc1ac929ff2c
