import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryStateHandler {
  final Battery _battery = Battery();

  void listenToBatteryState(BuildContext context) {
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      String message;

      switch (state) {
        case BatteryState.charging:
          message = "Cihaz þarj oluyor";
          break;
        case BatteryState.full:
          message = "Batarya dolu";
          break;
        case BatteryState.discharging:
          message = "Þarjdan çýkarýldý";
          break;
        default:
          message = "Batarya durumu bilinmiyor";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }
}
