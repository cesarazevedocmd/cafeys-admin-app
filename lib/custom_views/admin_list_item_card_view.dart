import 'package:cafeysadmin/custom_views/app_title_view.dart';
import 'package:cafeysadmin/model/admin.dart';
import 'package:cafeysadmin/util/app_assets.dart';
import 'package:cafeysadmin/util/app_constants.dart';
import 'package:cafeysadmin/util/app_space.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:flutter/material.dart';

class AdminListItemCardView extends StatelessWidget {
  final String assetIcon = AppAssets.adminIcon();
  final Admin item;
  final ValueChanged<Admin> itemClick;

  AdminListItemCardView({
    required this.item,
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
                      text: item.name ?? AppStrings.empty,
                      maxLines: AppConstants.VALUE_3.toInt(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () => itemClick(item),
      ),
    );
  }
}
