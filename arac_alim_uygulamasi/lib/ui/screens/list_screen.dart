// lib/ui/screens/list_screen.dart
import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Araç Listesi'),
      ),
      body: const Center(
        child: Text('İlk hafta: list screen placeholder'),
      ),
    );
  }
}
