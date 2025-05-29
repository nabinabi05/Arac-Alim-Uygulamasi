import 'package:flutter/material.dart';
import 'screen_template.dart';

class ProfileScreen extends StatelessWidget {
  final NavigateCallback onNavigate;
  final bool isLoggedIn;

  const ProfileScreen({
    Key? key,
    required this.onNavigate,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      onNavigate: onNavigate,
      isLoggedIn: isLoggedIn,
      child: const Center(
        child: Text('Profil Sayfası\nHoş geldiniz!'),
      ),
    );
  }
}
