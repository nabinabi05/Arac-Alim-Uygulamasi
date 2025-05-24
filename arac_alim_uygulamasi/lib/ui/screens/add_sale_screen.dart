// File: lib/ui/screens/add_sale_screen.dart
import 'package:flutter/material.dart';
import 'screen_template.dart';

class AddSaleScreen extends StatelessWidget {
  final NavigateCallback onNavigate;
  final bool isLoggedIn;

  const AddSaleScreen({Key? key, required this.onNavigate, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Satışa Araç Ekle',
      onNavigate: onNavigate,
      isLoggedIn: isLoggedIn,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Araç Başlığı',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Açıklama',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Fiyat',
                  prefixText: '₺ ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => onNavigate('Profil'),
                child: const Text('Kaydet ve Profili Gör'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
