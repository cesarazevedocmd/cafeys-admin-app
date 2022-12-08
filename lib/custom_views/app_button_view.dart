import 'package:cafeysadmin/util/app_constants.dart';
import 'package:flutter/material.dart';

class AppButtonView extends StatelessWidget {
  final VoidCallback onClick;
  final String text;
  final TextStyle? textStyle;
  final AppButtonType type;
  final ButtonStyle? buttonStyle;

  const AppButtonView({
    required this.text,
    required this.onClick,
    this.type = AppButtonType.primary,
    this.textStyle,
    this.buttonStyle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var defaultShape = MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.VALUE_8),
      ),
    );

    var safeButtonStyle = buttonStyle?.copyWith(shape: defaultShape) ?? ButtonStyle(shape: defaultShape);

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(onPressed: onClick, style: safeButtonStyle, child: Text(text, style: textStyle));
      case AppButtonType.secondary:
        return OutlinedButton(onPressed: onClick, style: safeButtonStyle, child: Text(text, style: textStyle));
    }
  }
}

enum AppButtonType {
  primary,
  secondary,
}
