import 'package:flutter/material.dart';

/// Signature for navigating between pages.
typedef NavigateCallback = void Function(String page, [String id]);

/// A common Scaffold with drawer, AppBar and FAB.
class ScreenTemplate extends StatelessWidget {
  final NavigateCallback onNavigate;
  final bool isLoggedIn;
  final Widget child;

  const ScreenTemplate({
    Key? key,
    required this.onNavigate,
    required this.isLoggedIn,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('AraçAlım',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            ListTile(
              title: const Text('Anasayfa'),
              onTap: () => onNavigate('Home'),
            ),
            ListTile(
              title: const Text('Araç Listesi'),
              onTap: () => onNavigate('List'),
            ),
            ListTile(
              title: const Text('İlan Ver'),
              onTap: () => onNavigate('AddSale'),
              enabled: isLoggedIn,
            ),
            if (isLoggedIn) ...[
              ListTile(
                title: const Text('Profil'),
                onTap: () => onNavigate('Profile'),
              ),
              ListTile(
                title: const Text('Çıkış Yap'),
                onTap: () => onNavigate('Logout'),
              ),
            ] else ...[
              ListTile(
                title: const Text('Giriş Yap'),
                onTap: () => onNavigate('Login'),
              ),
              ListTile(
                title: const Text('Kayıt Ol'),
                onTap: () => onNavigate('Signup'),
              ),
            ],
          ],
        ),
      ),
      appBar: AppBar(title: const Text('AraçAlım')),
      body: child,
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              onPressed: () => onNavigate('AddSale'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
