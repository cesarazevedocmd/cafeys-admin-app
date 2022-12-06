import 'package:cafeysadmin/custom_views/app_subtitle_view.dart';
import 'package:cafeysadmin/util/app_colors.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:flutter/material.dart';

enum AppToastType { success, error }

class AppToast {
  static showNotImplemented(BuildContext context) {
    error(context, AppStrings.notImplemented);
  }

  static success(BuildContext context, String text) {
    showSnackBar(context, text, AppToastType.success);
  }

  static error(BuildContext context, String text) {
    showSnackBar(context, text, AppToastType.error);
  }

  static showSnackBar(BuildContext context, String text, AppToastType type) {
    Color color;
    Icon icon;

    switch (type) {
      case AppToastType.success:
        color = AppColors.green;
        icon = const Icon(Icons.check_circle, color: AppColors.white);
        break;
      case AppToastType.error:
        color = AppColors.secondary;
        icon = const Icon(Icons.error, color: AppColors.white);
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            icon,
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AppSubtitleView(
                  text: text,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
