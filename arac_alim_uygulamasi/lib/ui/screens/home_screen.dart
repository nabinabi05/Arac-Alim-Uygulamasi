import 'package:flutter/material.dart';
import 'screen_template.dart';

class HomeScreen extends StatelessWidget {
  final NavigateCallback onNavigate;
  final bool isLoggedIn;

  const HomeScreen({
    Key? key,
    required this.onNavigate,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      onNavigate: onNavigate,
      isLoggedIn: isLoggedIn,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => onNavigate('List'),
              child: const Text('Araç Listesi'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  isLoggedIn ? () => onNavigate('AddSale') : null,
              child: const Text('İlan Ver'),
            ),
          ],
        ),
      ),
    );
  }
}
