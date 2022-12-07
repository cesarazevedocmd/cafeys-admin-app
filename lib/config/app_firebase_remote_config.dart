import 'package:cafeysadmin/util/app_constants.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class AppFirebaseRemoteConfig {
  static late FirebaseRemoteConfig _remoteConfig;

  static Future initRemoteConfig() async {
    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: Duration(seconds: AppConstants.VALUE_10.toInt()),
        minimumFetchInterval: Duration(hours: AppConstants.VALUE_12.toInt()),
      ),
    );
    await _remoteConfig.setDefaults(_defaultConfigs);
    RemoteConfigValue(null, ValueSource.valueStatic);
  }

  static Future fetch() async {
    await _remoteConfig.fetchAndActivate();
  }

  static String? getHostUrl() {
    String host = _remoteConfig.getString("hostApi");
    if (host.isEmpty || (!host.startsWith("http://") && !host.startsWith("https://"))) {
      return null;
    }
    return host;
  }

  static String getHostPublicValue() {
    return _remoteConfig.getString("hostPublicValue");
  }

  static final Map<String, dynamic> _defaultConfigs = <String, dynamic>{
    "hostApi": "http://192.168.1.9:8080/api",
    "hostPublicValue": "",
  };
}
