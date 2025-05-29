// File: lib/ui/screens/add_sale_screen.dart

import 'package:flutter/material.dart';
import '../../models/car.dart';
import '../../services/car_repository.dart';
import 'screen_template.dart';

/// Signature for navigating between pages.
typedef NavigateCallback = void Function(String page, [String id]);

class AddSaleScreen extends StatefulWidget {
  final NavigateCallback onNavigate;
  final bool isLoggedIn;

  const AddSaleScreen({
    Key? key,
    required this.onNavigate,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  _AddSaleScreenState createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _brandCtrl.dispose();
    _modelCtrl.dispose();
    _yearCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    // id=0 is a placeholder; your LocalDbService will assign the real AUTO_INCREMENT id
    final car = Car(
      id: 0,
      brand: _brandCtrl.text.trim(),
      modelName: _modelCtrl.text.trim(),
      year: int.parse(_yearCtrl.text.trim()),
      price: double.parse(_priceCtrl.text.trim()),
      description: _descCtrl.text.trim(),
    );

    final success = await CarRepository().addCar(car);

    setState(() => _submitting = false);

    if (success) {
      // Go back to the list page
      widget.onNavigate('List');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Araç eklenirken hata oluştu')),
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Marka
              TextFormField(
                controller: _brandCtrl,
                decoration: const InputDecoration(
                  labelText: 'Marka',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Marka girin' : null,
              ),
              const SizedBox(height: 16),

              // Model
              TextFormField(
                controller: _modelCtrl,
                decoration: const InputDecoration(
                  labelText: 'Model',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Model girin' : null,
              ),
              const SizedBox(height: 16),

              // Yıl
              TextFormField(
                controller: _yearCtrl,
                decoration: const InputDecoration(
                  labelText: 'Yıl',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Yıl girin';
                  }
                  final y = int.tryParse(v.trim());
                  if (y == null || y < 1900 || y > DateTime.now().year) {
                    return 'Geçerli yıl girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Fiyat
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(
                  labelText: 'Fiyat (TL)',
                  prefixText: '₺ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Fiyat girin';
                  }
                  final p = double.tryParse(v.trim());
                  if (p == null || p <= 0) {
                    return 'Geçerli fiyat girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Açıklama
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Submit butonu
              _submitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Araç Ekle'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
