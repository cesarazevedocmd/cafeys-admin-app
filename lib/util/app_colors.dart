import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.brown;

  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color secondary = Color(0xFFE0534A);

  static const Color onSecondary = Color(0xFF8A942F);

  static const Color surface = Color(0xFF539AE0);

  static const Color onSurface = Color(0xFF539AE0);

  static const Color white = Colors.white;

  static const Color red = Colors.red;

  static const Color darkRed = Color(0xFF960000);

  static const Color redAccent = Colors.redAccent;

  static const Color green = Colors.lightGreen;

  static const Color black = Colors.black;

  static const Color grey = Colors.grey;

  static const Color orange = Colors.deepOrange;

  static MaterialColor materialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
