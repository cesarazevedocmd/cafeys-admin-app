import 'package:cafeysadmin/util/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppLine {
  static Widget horizontal({Color? color}) {
    var safeColor = (color == null) ? AppColors.black.withOpacity(0.3) : color;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: safeColor,
            width: 1,
          ),
        ),
      ),
    );
  }

  static Widget vertical({Color? color, double? width, double? height}) {
    var safeColor = (color == null) ? AppColors.black.withOpacity(0.3) : color;

    return Container(
      height: height,
      width: width,
      color: safeColor,
    );
  }
}
