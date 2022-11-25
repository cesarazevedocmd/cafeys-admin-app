import 'package:connectivity_plus/connectivity_plus.dart';

class Network {
  static final Connectivity _connectivity = Connectivity();

  static Future<bool> isConnected() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    switch (result) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        return true;
      case ConnectivityResult.none:
        return false;
      default:
        return false;
    }
  }
}
