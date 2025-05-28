import 'package:sensors_plus/sensors_plus.dart';
class SensorService {
  void startAccelerometer() {
    accelerometerEvents.listen((e) => print('Acc: ${e.x},${e.y},${e.z}'));
  }
  void startGyroscope() {
    gyroscopeEvents.listen((e) => print('Gyro: ${e.x},${e.y},${e.z}'));
  }
}
