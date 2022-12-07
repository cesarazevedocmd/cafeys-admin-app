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

  static String? getHostTestUrl() {
    String host = _remoteConfig.getString("hostTestApi");
    if (host.isEmpty || (!host.startsWith("http://") && !host.startsWith("https://"))) return null;
    return host;
  }

  static String getHostPublicValue() {
    return _remoteConfig.getString("hostPublicValue");
  }

  static String getSupportEmail() {
    return _remoteConfig.getString("supportEmail");
  }

  static String getSupportWhatsApp() {
    return _remoteConfig.getString("supportWhatsApp");
  }

  static String? getPrivacyPolicyUrl() {
    String termsAndPolicies = _remoteConfig.getString("privacyPolicyUrl");
    if (termsAndPolicies.isEmpty ||
        (!termsAndPolicies.startsWith("http://") && !termsAndPolicies.startsWith("https://"))) return null;
    return termsAndPolicies;
  }

  static String? getTermsOfUseUrl() {
    String termsAndPolicies = _remoteConfig.getString("termsOfUseUrl");
    if (termsAndPolicies.isEmpty ||
        (!termsAndPolicies.startsWith("http://") && !termsAndPolicies.startsWith("https://"))) return null;
    return termsAndPolicies;
  }

  static final Map<String, dynamic> _defaultConfigs = <String, dynamic>{
    "hostApi": "https://api-hmg.mmsolucaotextil.com.br:8080/api-dev",
    "hostPublicValue": "@t54/34Mt3",
  };
}
