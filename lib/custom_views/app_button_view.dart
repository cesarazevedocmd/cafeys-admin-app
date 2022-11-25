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
    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(onPressed: onClick, child: Text(text, style: textStyle), style: buttonStyle);
      case AppButtonType.secondary:
        return OutlinedButton(onPressed: onClick, child: Text(text, style: textStyle), style: buttonStyle);
    }
  }
}

enum AppButtonType {
  primary,
  secondary,
}
