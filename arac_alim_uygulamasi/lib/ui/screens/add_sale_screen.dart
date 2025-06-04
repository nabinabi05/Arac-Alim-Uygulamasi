// lib/ui/screens/add_sale_screen.dart

import 'dart:io'; // (Directory.current) için
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/repositories.dart';  // carRepoProvider
import '../../providers/ai_provider.dart';   // aiServiceProvider
import '../../utils/ai_service.dart';        // AiService
import 'screen_template.dart';

class AddSaleScreen extends ConsumerStatefulWidget {
  const AddSaleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends ConsumerState<AddSaleScreen> {
  final _formKey = GlobalKey<FormState>();

  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  double? _latitude;
  double? _longitude;
  bool _locationPermissionGranted = false;
  bool _isGettingLocation = false;

  late final _carRepo = ref.read(carRepoProvider);
  bool _aiLoading = false;
  bool _aiInitialized = false;

  /// Hata mesajını tutan değişken
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  /// `.env` dosyasını yükleyerek OpenRouter API anahtarının hazır olmasını sağlar.
  /// Hata oluşursa `_errorMessage`'a yazar.
  Future<void> _initializeAiIfNeeded() async {
    if (_aiInitialized) return;
    try {
      // .env'in bulunduğu dizini konsolda görebilmek için:
      debugPrint("→ Current working directory: ${Directory.current.path}");

      await dotenv.load();
      debugPrint("→ .env yüklendi, OPENROUTER_API_KEY: ${dotenv.env['OPENROUTER_API_KEY']}");
      _aiInitialized = true;
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      rethrow;
    }
  }

  Future<void> _checkLocationPermission() async {
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
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitude = pos.latitude;
        _longitude = pos.longitude;
      });
    } catch (e) {
      debugPrint('Konum hatası: $e');
      setState(() {
        _errorMessage = 'Konum alınırken hata: $e';
      });
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  /// AI’dan tahmini fiyat alıp kullanıcıya gösteren dialog
  Future<void> _showAiPriceDialog() async {
    final loc = AppLocalizations.of(context)!;
    setState(() {
      _errorMessage = null;
    });

    // 1) Zorunlu alanları kontrol et
    final brandText = _brandController.text.trim();
    final modelText = _modelController.text.trim();
    final yearText = _yearController.text.trim();
    final descriptionText = _descriptionController.text.trim();

    if (brandText.isEmpty || modelText.isEmpty || yearText.isEmpty) {
      setState(() {
        _errorMessage = loc.fillAllFields;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.fillAllFields),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (!_locationPermissionGranted) {
      setState(() {
        _errorMessage = loc.locationPermissionDenied;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.locationPermissionDenied),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (_latitude == null || _longitude == null) {
      setState(() {
        _errorMessage = loc.locationNotReady;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.locationNotReady),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final intYear = int.tryParse(yearText) ?? 0;
    if (intYear < 1900) {
      setState(() {
        _errorMessage = loc.invalidYear;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.invalidYear),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 2) AI’dan tahmin al
    setState(() {
      _aiLoading = true;
      _errorMessage = null;
    });

    try {
      // .env’i yükle (API anahtarını tanımlamak için)
      await _initializeAiIfNeeded();

      // AI servisine istek at
      final aiService = ref.read(aiServiceProvider);
      final predicted = await aiService.predictPrice(
        brand: brandText,
        modelName: modelText,
        year: intYear,
        description: descriptionText,
      );

      // Kullanıcıya dialog göster
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(loc.predictedPriceTitle),
          content: Text(
            loc.predictedPriceContent(predicted.toStringAsFixed(2)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Sadece dialog’u kapat
              },
              child: Text(loc.ignoreButton),
            ),
            ElevatedButton(
              onPressed: () {
                // Tahmini fiyatı forma otomatik yaz
                _priceController.text = predicted.toStringAsFixed(2);
                Navigator.pop(ctx);
              },
              child: Text(loc.usePriceButton),
            ),
          ],
        ),
      );
    } on DioException catch (e) {
      final errorMsg = e.response?.data.toString() ?? e.message;
      setState(() {
        _errorMessage = 'API Hatası: $errorMsg';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${loc.aiError} $errorMsg'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      debugPrint('AI veya dotenv hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${loc.aiError} $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _aiLoading = false;
      });
    }
  }

  /// Manuel “Kaydet” butonuna basıldığında (AI kullanılmadan veya AI’dan gelen değer formda)
  Future<void> _submitForm() async {
    final loc = AppLocalizations.of(context)!;
    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;
    if (!_locationPermissionGranted) {
      setState(() {
        _errorMessage = loc.locationPermissionDenied;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.locationPermissionDenied),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (_latitude == null || _longitude == null) {
      setState(() {
        _errorMessage = loc.locationNotReady;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.locationNotReady),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final brandText = _brandController.text.trim();
    final modelText = _modelController.text.trim();
    final yearText = _yearController.text.trim();
    final priceText = _priceController.text.trim();
    final descriptionText = _descriptionController.text.trim();

    if (brandText.isEmpty ||
        modelText.isEmpty ||
        yearText.isEmpty ||
        priceText.isEmpty) {
      setState(() {
        _errorMessage = loc.fillAllFields;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.fillAllFields),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final intYear = int.tryParse(yearText) ?? 0;
    if (intYear < 1900) {
      setState(() {
        _errorMessage = loc.invalidYear;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.invalidYear),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final priceNum = double.tryParse(priceText.replaceAll(',', '.')) ?? 0.0;
    if (priceNum <= 0) {
      setState(() {
        _errorMessage = loc.invalidPrice;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.invalidPrice),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      final latFixed = double.parse(_latitude!.toStringAsFixed(6));
      final lonFixed = double.parse(_longitude!.toStringAsFixed(6));

      // _carRepo üzerinden API’ye kaydet
      await _carRepo.createCar(
        brand: brandText,
        modelName: modelText,
        year: intYear,
        price: priceNum,
        description: descriptionText,
        latitude: latFixed,
        longitude: lonFixed,
      );

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.listingSuccess),
          backgroundColor: Colors.green,
        ),
      );
    } on DioException catch (e) {
      final errorMsg = e.response?.data.toString() ?? e.message;
      setState(() {
        _errorMessage = 'API Hatası: $errorMsg';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${loc.listingError} $errorMsg'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      debugPrint('Beklenmeyen hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${loc.unexpectedError} $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return ScreenTemplate(
      title: loc.createListing,
      currentIndex: 1,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isGettingLocation)
                    const Center(child: CircularProgressIndicator()),
                  if (!_isGettingLocation && _latitude != null && _longitude != null)
                    Text(
                      loc.coordinatesFormat(
                        _latitude!.toStringAsFixed(6),
                        _longitude!.toStringAsFixed(6),
                      ),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  if (!_isGettingLocation && !_locationPermissionGranted)
                    Column(
                      children: [
                        Text(
                          loc.locationPermissionDenied,
                          style: const TextStyle(fontSize: 14, color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _checkLocationPermission,
                          child: Text(loc.requestPermission),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _brandController,
                          decoration: InputDecoration(labelText: loc.brandLabel),
                          validator: (val) =>
                              (val == null || val.isEmpty) ? loc.brandRequired : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _modelController,
                          decoration: InputDecoration(labelText: loc.modelLabel),
                          validator: (val) =>
                              (val == null || val.isEmpty) ? loc.modelRequired : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _yearController,
                          decoration: InputDecoration(labelText: loc.yearLabel),
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null || val.isEmpty) return loc.yearRequired;
                            final yearNum = int.tryParse(val);
                            return (yearNum == null || yearNum < 1900)
                                ? loc.invalidYear
                                : null;
                          },
                        ),
                        const SizedBox(height: 12),
                        // Artık kullanıcı manuel yazabilecek:
                        TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(labelText: loc.priceLabel),
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null || val.isEmpty) return loc.priceRequired;
                            final priceNum =
                                double.tryParse(val.replaceAll(',', '.'));
                            return (priceNum == null || priceNum <= 0)
                                ? loc.invalidPrice
                                : null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _descriptionController,
                          decoration:
                              InputDecoration(labelText: loc.descriptionLabel),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),

                        // AI ile tahmin butonu:
                        ElevatedButton.icon(
                          onPressed: _aiLoading ? null : _showAiPriceDialog,
                          icon: _aiLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.auto_graph),
                          label: Text(loc.getAiPrice),
                        ),

                        const SizedBox(height: 12),
                        // Manuel kaydet butonu:
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(loc.saveButton),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Hata mesajını kırmızı bant içinde gösteriyoruz:
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              color: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
