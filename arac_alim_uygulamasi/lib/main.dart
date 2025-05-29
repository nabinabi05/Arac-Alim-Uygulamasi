import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/screens/screen_template.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/list_screen.dart';
import 'ui/screens/add_sale_screen.dart';
import 'ui/screens/detail_screen.dart';
import 'ui/screens/profile_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/signup_screen.dart';
import 'services/auth_provider.dart';

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
  ConsumerState<HomeScreenWrapper> createState() =>
      _HomeScreenWrapperState();
}

class _HomeScreenWrapperState
    extends ConsumerState<HomeScreenWrapper> {
  String _currentPage = 'Home';
  String _selectedId = '';

  void _navigate(String page, [String id = '']) {
    if (page == 'Logout') {
      ref.read(authProvider.notifier).logout();
      page = 'Home';
    }
    setState(() {
      _currentPage = page;
      _selectedId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoggedIn =
        authState.status == AuthStatus.authenticated;

    switch (_currentPage) {
      case 'Home':
        return HomeScreen(
            onNavigate: _navigate, isLoggedIn: isLoggedIn);
      case 'List':
        return ListScreen(
            onNavigate: _navigate, isLoggedIn: isLoggedIn);
      case 'AddSale':
        return AddSaleScreen(
            onNavigate: _navigate, isLoggedIn: isLoggedIn);
      case 'Detail':
        return DetailScreen(
          onNavigate: _navigate,
          isLoggedIn: isLoggedIn,
          id: _selectedId,
        );
      case 'Profile':
        return ProfileScreen(
            onNavigate: _navigate, isLoggedIn: isLoggedIn);
      case 'Login':
        return LoginScreen(
            onNavigate: _navigate, isLoggedIn: isLoggedIn);
      case 'Signup':
        return SignupScreen(
            onNavigate: _navigate, isLoggedIn: isLoggedIn);
      default:
        return HomeScreen(
            onNavigate: _navigate, isLoggedIn: isLoggedIn);
    }
  }
}
