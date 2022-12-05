import 'dart:convert';

import 'package:cafeysadmin/config/prefs.dart';
import 'package:cafeysadmin/model/user.dart';

class UserManager {
  static const String _userObjectTag = "user_object";

  static Future<User?> getUser() async {
    String jsonUser = await Prefs.getString(_userObjectTag);
    if (jsonUser.isNotEmpty) return User.fromJson(json.decode(jsonUser));
    return null;
  }

  static setUser(User? user) async {
    if (user != null) {
      var userEncoded = json.encode(user.toJson());
      await Prefs.setString(_userObjectTag, userEncoded);
      await setEmail(user.email);
    } else {
      Prefs.setString(_userObjectTag, "");
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

  static removeUser() async {
    await setUser(null);
  }

  static removeToken() async {
    await setToken("");
  }
}
