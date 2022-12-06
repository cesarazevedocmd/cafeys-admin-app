import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppFunctions {
  static hideKeyboard(BuildContext context) async {
    try {
      FocusScopeNode currentFocus = FocusScope.of(context);
      currentFocus.requestFocus(FocusNode());
    } catch (error) {
      if (kDebugMode) {
        print("ERROR hideKeyboard");
      }
    }
  }
}
