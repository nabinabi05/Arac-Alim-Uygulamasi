import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static Future<bool> isConnected() async {
    var result = await Connectivity().checkConnectivity();
    return result == ConnectivityResult.mobile || result == ConnectivityResult.wifi;
  }
}
static void listenConnectionChanges(Function(bool isConnected) onChange) {
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    bool isConnected = result == ConnectivityResult.mobile || result == ConnectivityResult.wifi;
    onChange(isConnected);
  });
}
