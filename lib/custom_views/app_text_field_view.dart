import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFieldView extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final String? label;
  final TextStyle? labelStyle;
  final String? errorText;
  final String? helpText;
  final int? maxLength;
  final InputDecoration? decoration;
  final AppTextFieldBorderType borderType;
  final IconButton? suffixIcon;
  final Icon? prefixIcon;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatter;
  final int? minLines;
  final int? maxLines;
  final TextCapitalization capitalization;
  final TextInputAction actionEnterClick;
  final bool isPassword;
  final bool enable;

  const AppTextFieldView({
    required this.controller,
    this.validator,
    this.borderType = AppTextFieldBorderType.bottom,
    this.capitalization = TextCapitalization.none,
    this.actionEnterClick = TextInputAction.next,
    this.maxLength,
    this.hintText,
    this.label,
    this.labelStyle,
    this.helpText,
    this.errorText,
    this.suffixIcon,
    this.prefixIcon,
    this.decoration,
    this.inputType,
    this.inputFormatter,
    this.minLines,
    this.maxLines,
    this.isPassword = false,
    this.enable = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLength: maxLength,
      keyboardType: inputType,
      inputFormatters: inputFormatter,
      minLines: minLines,
      maxLines: maxLines,
      textCapitalization: capitalization,
      textInputAction: actionEnterClick,
      obscureText: isPassword,
      decoration: getDecoration(),
      enabled: enable,
    );
  }

  InputDecoration getDecoration() {
    InputDecoration tempInputDecoration = decoration ?? const InputDecoration();

    if (hintText != null) tempInputDecoration = tempInputDecoration.copyWith(hintText: hintText);
    if (label != null) tempInputDecoration = tempInputDecoration.copyWith(labelText: label);
    if (labelStyle != null) tempInputDecoration = tempInputDecoration.copyWith(labelStyle: labelStyle);
    if (errorText != null) tempInputDecoration = tempInputDecoration.copyWith(errorText: errorText);
    if (helpText != null) tempInputDecoration = tempInputDecoration.copyWith(helperText: helpText);
    if (suffixIcon != null) tempInputDecoration = tempInputDecoration.copyWith(suffixIcon: suffixIcon);
    if (prefixIcon != null) tempInputDecoration = tempInputDecoration.copyWith(icon: prefixIcon);

    switch (borderType) {
      case AppTextFieldBorderType.none:
        tempInputDecoration = tempInputDecoration.copyWith(border: InputBorder.none);
        break;
      case AppTextFieldBorderType.bottom:
        tempInputDecoration = tempInputDecoration.copyWith(enabledBorder: const UnderlineInputBorder());
        break;
      case AppTextFieldBorderType.all:
        tempInputDecoration = tempInputDecoration.copyWith(border: const OutlineInputBorder());
        break;
    }

    return tempInputDecoration;
  }
}

enum AppTextFieldBorderType {
  none,
  bottom,
  all,
}
