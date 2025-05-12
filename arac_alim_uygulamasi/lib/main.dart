import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

class SystemEventWatcher {
  final Connectivity _connectivity = Connectivity();
  final Battery _battery = Battery();

  void listenToEvents(BuildContext context) {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      final isConnected = result != ConnectivityResult.none;
      _showSnackbar(context, isConnected ? "Bağlantı geldi" : "Bağlantı koptu");
    });

    _battery.batteryLevel.then((level) {
      if (level < 20) {
        _showSnackbar(context, "Batarya seviyesi düşük: %$level");
      }
    });
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
