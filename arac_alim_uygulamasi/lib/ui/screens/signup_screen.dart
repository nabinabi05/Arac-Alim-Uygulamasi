// File: lib/ui/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'screen_template.dart';

class SignUpScreen extends StatelessWidget {
  final NavigateCallback onNavigate;
  final bool isLoggedIn;

  const SignUpScreen({Key? key, required this.onNavigate, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Kayıt Ol',
      onNavigate: onNavigate,
      isLoggedIn: isLoggedIn,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                labelText: 'İsim',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Şifre',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => onNavigate('Anasayfa'),
              child: const Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}