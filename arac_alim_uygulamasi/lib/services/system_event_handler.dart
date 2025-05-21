import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

class SystemEventWatcher {
  final Connectivity _connectivity = Connectivity();
  final Battery _battery = Battery();

  void listenToEvents(BuildContext context) {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      final isConnected = result != ConnectivityResult.none;
      _showSnackbar(context, isConnected ? "Ba�lant� geldi" : "Ba�lant� koptu");
    });

    _battery.batteryLevel.then((level) {
      if (level < 20) {
        _showSnackbar(context, "Batarya seviyesi d���k: %$level");
      }
    });
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  _connectivity.onConnectivityChanged.listen((result) {
    if (result == ConnectivityResult.none) {
     print("�nternet ba�lant�s� yok");
  } else {
     print("�nternete ba�l�: $result");
  }
});

}
