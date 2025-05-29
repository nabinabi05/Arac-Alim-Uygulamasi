import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_provider.dart';
import 'screen_template.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  final void Function(String) onNavigate;
  final bool isLoggedIn;

  const SignUpScreen({
    Key? key,
    required this.onNavigate,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
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

    // Başarılı kayıt sonrası Login’e dön
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.status == AuthStatus.unauthenticated) {
        widget.onNavigate('Login');
      }
    });

    return AppScaffold(
      title: 'Kayıt Ol',
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
                  : () => ref.read(authProvider.notifier).register(_emailCtrl.text, _passCtrl.text),
              child: Text(authState.status == AuthStatus.loading ? 'Bekleyiniz…' : 'Kayıt Ol'),
            ),
            if (authState.status == AuthStatus.error)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(authState.error!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 16),
            TextButton(onPressed: () => widget.onNavigate('Login'), child: const Text('Giriş Yap')),
          ],
        ),
      ),
    );
  }
}
