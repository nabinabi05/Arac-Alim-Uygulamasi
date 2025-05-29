import 'package:flutter/material.dart';
import '../../models/car.dart';
import '../../services/car_repository.dart';
import 'screen_template.dart';

class AddSaleScreen extends StatefulWidget {
  final NavigateCallback onNavigate;
  final bool isLoggedIn;

  const AddSaleScreen({
    Key? key,
    required this.onNavigate,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  State<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

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

    // Note: id=0 is a placeholder; sqflite will assign the real AUTO_INCREMENT id
    final car = Car(
      id: 0,
      brand: _brandCtrl.text,
      modelName: _modelCtrl.text,
      year: int.tryParse(_yearCtrl.text) ?? 0,
      price: double.tryParse(_priceCtrl.text) ?? 0,
      description: _descCtrl.text,
    );

    final ok = await CarRepository().addCar(car);
    if (ok) {
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
              TextFormField(
                controller: _brandCtrl,
                decoration: const InputDecoration(labelText: 'Marka'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Zorunlu alan' : null,
              ),
              TextFormField(
                controller: _modelCtrl,
                decoration: const InputDecoration(labelText: 'Model'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Zorunlu alan' : null,
              ),
              TextFormField(
                controller: _yearCtrl,
                decoration: const InputDecoration(labelText: 'Yıl'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || int.tryParse(v) == null ? 'Geçerli yıl girin' : null,
              ),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: 'Fiyat (TL)'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || double.tryParse(v) == null ? 'Geçerli fiyat girin' : null,
              ),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
