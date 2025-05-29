// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/auth_provider.dart';
import 'ui/screens/add_sale_screen.dart';
import 'ui/screens/detail_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/list_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/profile_screen.dart';
import 'ui/screens/signup_screen.dart';
import 'ui/screens/screen_template.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: AracAlimApp()));
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

class HomeScreenWrapper extends ConsumerStatefulWidget {
  const HomeScreenWrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreenWrapper> createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends ConsumerState<HomeScreenWrapper> {
  String _currentPage = 'Anasayfa';
  String? _detailId;

  final vehicles  = ['Araba A', 'Araba B', 'Araba C'];
  final favorites = ['Araba B'];

  void _navigate(String page) {
    if (page == 'Logout') {
      // Gerçek çıkış işlemi
      ref.read(authProvider.notifier).logout();
      setState(() => _currentPage = 'Login');
      return;
    }
    if (page.startsWith('Detail:')) {
      _detailId = page.split(':').last;
      setState(() => _currentPage = 'Detail');
      return;
    }
    setState(() => _currentPage = page);
  }

  @override
  Widget build(BuildContext context) {
  final authState  = ref.watch(authProvider);
  final isLoggedIn = authState.status == AuthStatus.authenticated;

  switch (_currentPage) {
    case 'Login':
      return LoginScreen(onNavigate: _navigate, isLoggedIn: isLoggedIn);

    case 'SignUp':
      return SignUpScreen(onNavigate: _navigate, isLoggedIn: isLoggedIn);

    case 'AddSale':
      return AddSaleScreen(onNavigate: _navigate, isLoggedIn: isLoggedIn);

    case 'Araçlar':
      return ListScreen(
        onNavigate: _navigate,
        items: vehicles,      // ← Burada isLoggedIn kaldırıldı
      );

    case 'Detail':
      return DetailScreen(
        onNavigate: _navigate,
        id: _detailId!,
        isLoggedIn: isLoggedIn,
      );

    case 'Profil':
      return ProfileScreen(
        onNavigate: _navigate,
        isLoggedIn: isLoggedIn,
        favorites: favorites,
      );

    case 'Anasayfa':
    default:
      return HomeScreen(onNavigate: _navigate, isLoggedIn: isLoggedIn);
  }
}
}
