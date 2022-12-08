import 'package:cafeysadmin/config/admin_manager.dart';
import 'package:cafeysadmin/custom_views/app_button_view.dart';
import 'package:cafeysadmin/custom_views/app_subtitle_view.dart';
import 'package:cafeysadmin/custom_views/app_title_view.dart';
import 'package:cafeysadmin/util/app_colors.dart';
import 'package:cafeysadmin/util/app_constants.dart';
import 'package:cafeysadmin/util/app_space.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:flutter/material.dart';

class AppWidget {
  static Widget empty({double width = 0, double height = 0}) {
    return SizedBox(width: width, height: height);
  }

  static Widget box({required double size, required Widget widget}) {
    return SizedBox(width: size, height: size, child: widget);
  }

  static Widget sizeItem({required double? width, required double? height, required Widget widget}) {
    return SizedBox(width: width, height: height, child: widget);
  }

  static void showProgressDialog(BuildContext context, {bool dismissEnable = false}) {
    showDialog(
      context: context,
      barrierDismissible: dismissEnable,
      builder: (context) {
        return SimpleDialog(
          children: [
            Center(
              child: box(
                size: 40,
                widget: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget loading({String? text = AppStrings.loading}) {
    const Color itemColor = AppColors.primary;
    var description = Text(
      text ?? "",
      semanticsLabel: text,
      style: const TextStyle(
        fontStyle: FontStyle.italic,
        color: itemColor,
      ),
    );
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(itemColor)),
            AppSpace.vertical(15),
            text == null ? empty() : description,
          ],
        ),
      ),
    );
  }

  static Widget error(
    String imageAsset, {
    VoidCallback? onClick,
    String onClickText = "notFoundText",
    Color background = AppColors.white,
    String? description,
  }) {
    if (onClick == null) throw Exception("onClick can't be null");

    Widget button = AppButtonView(text: onClickText, onClick: onClick);

    List<Widget> customView = [
      Opacity(
        opacity: AppConstants.VALUE_0_5,
        child: Image.asset(imageAsset, height: AppConstants.VALUE_250),
      ),
    ];
    if (description != null && description.isNotEmpty) {
      customView.add(AppSpace.vertical(AppConstants.VALUE_20));
      customView.add(
        AppSubtitleView(
          maxLines: AppConstants.VALUE_2.toInt(),
          align: TextAlign.center,
          color: AppColors.primary,
          italic: true,
          text: description,
        ),
      );
    }

    Column rowCustomView = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: customView,
    );

    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          rowCustomView,
          Positioned(bottom: AppConstants.VALUE_80, child: button),
        ],
      ),
    );
  }

  static RefreshIndicator refreshIndicator({
    required RefreshCallback onRefresh,
    required Widget child,
    Color color = AppColors.primary,
  }) {
    return RefreshIndicator(
      color: color,
      backgroundColor: AppColors.white,
      onRefresh: onRefresh,
      child: child,
    );
  }

  static AppBar helloAdminAppBar({List<Widget> actions = const []}) {
    return AppBar(
      title: FutureBuilder(
        initialData: null,
        future: AdminManager.getAdmin(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const AppTitleView(text: AppStrings.empty);
          }
          return AppTitleView(
            color: AppColors.white,
            text: "${AppStrings.hello}${AppStrings.comma} ${snapshot.data!.name!}",
            textSize: AppConstants.VALUE_20,
          );
        },
      ),
      actions: actions,
    );
  }
}
