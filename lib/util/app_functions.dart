import 'package:cafeysadmin/util/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  static String formatDate(DateTime? date) {
    if (date != null) {
      return DateFormat("dd/MM/yyyy").format(date);
    }
    return AppStrings.invalidDate;
  }
}
