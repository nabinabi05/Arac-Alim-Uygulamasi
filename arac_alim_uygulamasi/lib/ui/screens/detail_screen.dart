import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_provider.dart';
import 'screen_template.dart';

class DetailScreen extends ConsumerWidget {
  final void Function(String) onNavigate;
  final String id;
  final bool isLoggedIn;

  const DetailScreen({
    Key? key,
    required this.onNavigate,
    required this.id,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.status != AuthStatus.authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onNavigate('Login'));
      return const Scaffold(body: SizedBox.shrink());
    }

    return AppScaffold(
      title: 'İlan Detayı',
      onNavigate: onNavigate,
      isLoggedIn: isLoggedIn,
      body: Center(child: Text('Detaylar: $id')),
    );
  }
}
