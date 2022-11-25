import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<bool> getBool(String key) async {
    var prefs = await _getPref();
    return prefs.getBool(key) ?? false;
  }

  static setBool(String key, bool value) async {
    var prefs = await _getPref();
    prefs.setBool(key, value);
  }

  static Future<int> getInt(String key) async {
    var prefs = await _getPref();
    return prefs.getInt(key) ?? 0;
  }

  static setInt(String key, int value) async {
    var prefs = await _getPref();
    prefs.setInt(key, value);
  }

  static Future<String> getString(String key) async {
    var prefs = await _getPref();
    return prefs.getString(key) ?? "";
  }

  static setString(String key, String value) async {
    var prefs = await _getPref();
    prefs.setString(key, value ?? "");
  }

  static Future<double> getDouble(String key) async {
    var prefs = await _getPref();
    return prefs.getDouble(key) ?? 0.0;
  }

  static setDouble(String key, double value) async {
    var prefs = await _getPref();
    prefs.setDouble(key, value);
  }

  static Future<SharedPreferences> _getPref() async {
    return SharedPreferences.getInstance();
  }
}
