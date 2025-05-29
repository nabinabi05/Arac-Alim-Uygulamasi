import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_provider.dart';
import 'screen_template.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final void Function(String) onNavigate;
  final bool isLoggedIn;

  const LoginScreen({
    Key? key,
    required this.onNavigate,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Başarılı login sonrası otomatik yönlendir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.status == AuthStatus.authenticated) {
        widget.onNavigate('Anasayfa');
      }
    });

    return AppScaffold(
      title: 'Giriş Yap',
      onNavigate: widget.onNavigate,
      isLoggedIn: widget.isLoggedIn,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Şifre')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: authState.status == AuthStatus.loading
                  ? null
                  : () => ref.read(authProvider.notifier).login(_emailCtrl.text, _passCtrl.text),
              child: Text(authState.status == AuthStatus.loading ? 'Bekleyiniz…' : 'Giriş Yap'),
            ),
            if (authState.status == AuthStatus.error)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(authState.error!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 16),
            TextButton(onPressed: () => widget.onNavigate('SignUp'), child: const Text('Kayıt Ol')),
          ],
        ),
      ),
    );
  }
}
