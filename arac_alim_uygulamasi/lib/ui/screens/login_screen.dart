import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_provider.dart';
import 'screen_template.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final NavigateCallback onNavigate;
  final bool isLoggedIn;

  const LoginScreen({
    Key? key,
    required this.onNavigate,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    await ref
        .read(authProvider.notifier)
        .login(_emailCtrl.text, _passCtrl.text);
    setState(() => _loading = false);

    final st = ref.read(authProvider);
    if (st.status == AuthStatus.authenticated) {
      widget.onNavigate('Home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(st.error ?? 'Giriş başarısız')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      onNavigate: widget.onNavigate,
      isLoggedIn: widget.isLoggedIn,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailCtrl,
              decoration:
                  const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passCtrl,
              decoration:
                  const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Giriş Yap'),
                  ),
          ],
        ),
      ),
    );
  }
}
