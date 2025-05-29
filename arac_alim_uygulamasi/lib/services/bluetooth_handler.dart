import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothStatusHandler {
  Stream<BluetoothAdapterState> get _bluetoothStateStream =>
      FlutterBluePlus.adapterState;

  void listenToBluetoothChanges(BuildContext context) {
    _bluetoothStateStream.listen((state) {
      if (state == BluetoothAdapterState.on) {
        _showSnackbar(context, "Bluetooth açıldı");
      } else if (state == BluetoothAdapterState.off) {
        _showSnackbar(context, "Bluetooth kapatıldı");
      }
    });
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
