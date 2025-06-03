// lib/ui/screens/add_sale_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';

import '../../providers/repositories.dart'; // CarRepositoryApi
import 'screen_template.dart';
import '../../repositories/car_repository_api.dart'; // CarRepositoryApi

class AddSaleScreen extends ConsumerStatefulWidget {
  const AddSaleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends ConsumerState<AddSaleScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form alanları
  String _brand = '';
  String _model = '';
  String _year = '';
  String _price = '';
  String _description = '';

  // Konum için değişkenler
  double? _latitude;
  double? _longitude;
  bool _locationPermissionGranted = false;
  bool _isGettingLocation = false;

  // API reposu
  late final CarRepositoryApi _carRepo;

  @override
  void initState() {
    super.initState();
    // CarRepositoryApi örneğini alalım
    _carRepo = ref.read(carRepoProvider);
    // İzinleri kontrol edip, otomatik konum almaya çalışalım (isteğe bağlı)
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    // Konum izni isteniyor
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      setState(() {
        _locationPermissionGranted = true;
      });
      await _getCurrentLocation();
    } else {
      setState(() {
        _locationPermissionGranted = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      debugPrint('Konum alınırken hata: $e');
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_locationPermissionGranted) {
      // Eğer izin yoksa kullanıcıyı uyandır
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konum izni verilmedi! Lütfen ayarlardan izin verin.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konum henüz alınamadı. Lütfen bekleyin.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Form verilerini kaydet
    _formKey.currentState!.save();

    // Modeli uygun tipe çevir
    final intYear = int.tryParse(_year) ?? 0;
    final doublePrice = double.tryParse(_price.replaceAll(',', '.')) ?? 0.0;

    // API isteği: Örnek endpoint: POST /cars/
    try {
      final latFixed = double.parse(_latitude!.toStringAsFixed(6));
      final lonFixed = double.parse(_longitude!.toStringAsFixed(6));
      await _carRepo.createCar(
        brand: _brand,
        modelName: _model,
        year: intYear,
        price: doublePrice,
        description: _description,
        latitude: latFixed,
        longitude: lonFixed,
      );
      // Başarılı olursa kullanıcıyı anasayfaya yönlendirelim
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('İlan başarıyla oluşturuldu.'),
          backgroundColor: Colors.green,
        ),
      );
    } on DioException catch (e) {
      final errorMsg = e.response?.data.toString() ?? e.message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kaydetme hatası: $errorMsg'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Beklenmeyen hata: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      title: 'İlan Oluştur',
      currentIndex: 1,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // -- Konum Durumu Göstergesi --
            if (_isGettingLocation)
              const Center(child: CircularProgressIndicator()),
            if (!_isGettingLocation && _latitude != null && _longitude != null)
              Text(
                'Konum: ($_latitude, $_longitude)',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            if (!_isGettingLocation && !_locationPermissionGranted)
              Column(
                children: [
                  const Text(
                    'Konum izni verilmedi. Konum ekleyemezsiniz.',
                    style: TextStyle(fontSize: 14, color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _checkLocationPermission,
                    child: const Text('İzin İste'),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // -- İlan Formu --
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Marka'),
                    onSaved: (val) => _brand = val?.trim() ?? '',
                    validator: (val) => (val == null || val.isEmpty) ? 'Marka gerekli.' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Model'),
                    onSaved: (val) => _model = val?.trim() ?? '',
                    validator: (val) => (val == null || val.isEmpty) ? 'Model gerekli.' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Yıl'),
                    keyboardType: TextInputType.number,
                    onSaved: (val) => _year = val?.trim() ?? '',
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Yıl gerekli.';
                      final yearNum = int.tryParse(val);
                      return (yearNum == null || yearNum < 1900) ? 'Geçersiz yıl.' : null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Fiyat (₺)'),
                    keyboardType: TextInputType.number,
                    onSaved: (val) => _price = val?.trim() ?? '',
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Fiyat gerekli.';
                      final priceNum = double.tryParse(val.replaceAll(',', '.'));
                      return (priceNum == null || priceNum <= 0) ? 'Geçersiz fiyat.' : null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Açıklama'),
                    maxLines: 3,
                    onSaved: (val) => _description = val?.trim() ?? '',
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Kaydet'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
