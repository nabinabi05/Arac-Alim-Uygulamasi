// File: lib/main.dart
import 'package:flutter/material.dart';
import 'ui/screens/screen_template.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/signup_screen.dart';
import 'ui/screens/add_sale_screen.dart';
import 'ui/screens/list_screen.dart';
import 'ui/screens/detail_screen.dart';
import 'ui/screens/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AracAlimApp());
}

class AracAlimApp extends StatelessWidget {
  const AracAlimApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AraçAlım',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreenWrapper(),
    );
  }
}

class HomeScreenWrapper extends StatefulWidget {
  const HomeScreenWrapper({Key? key}) : super(key: key);
  @override
  _HomeScreenWrapperState createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends State<HomeScreenWrapper> {
  String _currentPage = 'Anasayfa';
  String? _detailId;
  bool _isLoggedIn = false;

  final vehicles  = ['Araba A', 'Araba B', 'Araba C'];
  final favorites = ['Araba B'];

  void _navigate(String page) {
    if (page == 'Logout') {
      setState(() {
        _isLoggedIn = false;
        _currentPage = 'Anasayfa';
      });
      return;
    }
    if (page == 'Login' || page == 'SignUp' || page == 'AddSale') {
      setState(() => _currentPage = page);
      return;
    }
    if (page.startsWith('Detail:')) {
      _detailId = page.split(':').last;
      setState(() => _currentPage = 'Detail');
      return;
    }
    // Simulate login success when navigating from Login → AddSale
    if (_currentPage == 'Login' && page == 'AddSale') {
      _isLoggedIn = true;
    }
    setState(() => _currentPage = page);
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentPage) {
      case 'Login':
        return LoginScreen(onNavigate: _navigate, isLoggedIn: _isLoggedIn);
      case 'SignUp':
        return SignUpScreen(onNavigate: _navigate, isLoggedIn: _isLoggedIn);
      case 'AddSale':
        return AddSaleScreen(onNavigate: _navigate, isLoggedIn: _isLoggedIn);
      case 'Araçlar':
        return ListScreen(onNavigate: _navigate, items: vehicles, isLoggedIn: _isLoggedIn);
      case 'Detail':
        return DetailScreen(onNavigate: _navigate, id: _detailId!, isLoggedIn: _isLoggedIn);
      case 'Profil':
      case 'Favoriler': // both routes now go to the same ProfileScreen
        return ProfileScreen(onNavigate: _navigate, isLoggedIn: _isLoggedIn, favorites: favorites);
      case 'Anasayfa':
      default:
        return HomeScreen(onNavigate: _navigate, isLoggedIn: _isLoggedIn);
    }
  }
}