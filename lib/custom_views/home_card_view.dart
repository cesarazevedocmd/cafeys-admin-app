import 'package:cafeysadmin/custom_views/app_subtitle_view.dart';
import 'package:cafeysadmin/custom_views/app_title_view.dart';
import 'package:cafeysadmin/util/app_constants.dart';
import 'package:cafeysadmin/util/app_space.dart';
import 'package:flutter/material.dart';

class HomeCardView extends StatelessWidget {
  final String assetIcon;
  final String title;
  final String subtitle;
  final Function itemClick;

  const HomeCardView({
    required this.assetIcon,
    required this.title,
    required this.subtitle,
    required this.itemClick,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        left: AppConstants.VALUE_10,
        top: AppConstants.VALUE_5,
        right: AppConstants.VALUE_5,
        bottom: AppConstants.VALUE_5,
      ),
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.only(
            left: AppConstants.VALUE_10,
            top: AppConstants.VALUE_10,
            right: AppConstants.VALUE_10,
            bottom: AppConstants.VALUE_10,
          ),
          child: Row(
            children: [
              Image.asset(assetIcon, height: AppConstants.VALUE_40),
              AppSpace.horizontal(AppConstants.VALUE_5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTitleView(
                      text: title,
                      maxLines: AppConstants.VALUE_3.toInt(),
                    ),
                    AppSpace.vertical(AppConstants.VALUE_5),
                    AppSubtitleView(
                      text: subtitle,
                      maxLines: AppConstants.VALUE_3.toInt(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () => itemClick(),
      ),
    );
  }
}
