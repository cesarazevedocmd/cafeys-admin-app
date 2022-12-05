import 'dart:convert';

import 'package:cafeysadmin/config/prefs.dart';
import 'package:cafeysadmin/model/admin.dart';

class AdminManager {
  static const String _adminObjectTag = "admin_object";

  static Future<Admin?> getAdmin() async {
    String jsonAdmin = await Prefs.getString(_adminObjectTag);
    if (jsonAdmin.isNotEmpty) return Admin.fromJson(json.decode(jsonAdmin));
    return null;
  }

  static setAdmin(Admin? admin) async {
    if (admin != null) {
      var adminEncoded = json.encode(admin.toJson());
      await Prefs.setString(_adminObjectTag, adminEncoded);
      await setEmail(admin.email);
    } else {
      Prefs.setString(_adminObjectTag, "");
    }
  }

  static setEmail(String? email) async {
    email ??= "";
    Prefs.setString("email", email);
  }

  static Future<String> getEmail() async {
    return await Prefs.getString("email");
  }

  static setPassword(String? password) async {
    password = password ?? "";
    Prefs.setString("password", password);
  }

  static Future<String> getPassword() async {
    return await Prefs.getString("password");
  }

  static removePassword() async {
    await setPassword("");
  }

  static Future<String> getToken() async {
    return await Prefs.getString("token");
  }

  static setToken(String? token) async {
    token ??= "";
    Prefs.setString("token", token);
  }

  static removeAdmin() async {
    await setAdmin(null);
  }

  static removeToken() async {
    await setToken("");
  }
}
