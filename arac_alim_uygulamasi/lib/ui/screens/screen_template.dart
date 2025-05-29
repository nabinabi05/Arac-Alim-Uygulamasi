// File: lib/ui/screens/screen_template.dart
import 'package:flutter/material.dart';

typedef NavigateCallback = void Function(String);

class AppScaffold extends StatelessWidget {
  final String title;
  final NavigateCallback onNavigate;
  final Widget body;
  final bool isLoggedIn;

  const AppScaffold({
    Key? key,
    required this.title,
    required this.onNavigate,
    required this.body,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          // Profil / Logout veya Login / Signup butonları
          if (isLoggedIn) ...[
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => onNavigate('Profil'),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => onNavigate('Logout'),
            ),
          ] else ...[
            TextButton(
              onPressed: () => onNavigate('Login'),
              child: const Text('Giriş', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => onNavigate('SignUp'),
              child: const Text('Kayıt', style: TextStyle(color: Colors.white)),
            ),
          ],

          // Menü ikonu en sağda
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
      ),

      // Sağdan kayan menü: giriş durumuna göre seçenekler
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Text(
                'AraçAlım',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            // Her zaman
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Ana Sayfa'),
              onTap: () {
                Navigator.of(context).pop();
                onNavigate('Anasayfa');
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Araçlar'),
              onTap: () {
                Navigator.of(context).pop();
                onNavigate('Araçlar');
              },
            ),

            const Divider(),

            // Girişli değilse login/signup
            if (!isLoggedIn) ...[
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Giriş Yap'),
                onTap: () {
                  Navigator.of(context).pop();
                  onNavigate('Login');
                },
              ),
              ListTile(
                leading: const Icon(Icons.app_registration),
                title: const Text('Kayıt Ol'),
                onTap: () {
                  Navigator.of(context).pop();
                  onNavigate('SignUp');
                },
              ),
            ] else ...[
              // Girişliyse profil
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profil'),
                onTap: () {
                  Navigator.of(context).pop();
                  onNavigate('Profil');
                },
              ),
            ],

            // Yalnızca girişliler için
            if (isLoggedIn) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.add_box),
                title: const Text('İlan Ver'),
                onTap: () {
                  Navigator.of(context).pop();
                  onNavigate('AddSale');
                },
              ),
            ],
          ],
        ),
      ),

      body: body,

      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              onPressed: () => onNavigate('AddSale'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
