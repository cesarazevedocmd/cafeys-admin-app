import 'package:cafeysadmin/config/admin_manager.dart';
import 'package:cafeysadmin/custom_views/app_subtitle_view.dart';
import 'package:cafeysadmin/custom_views/app_title_view.dart';
import 'package:cafeysadmin/util/app_assets.dart';
import 'package:cafeysadmin/util/app_colors.dart';
import 'package:cafeysadmin/util/app_constants.dart';
import 'package:cafeysadmin/util/app_space.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: ListView(
        children: [
          customCardView(
            assetIcon: AppAssets.adminIcon(),
            title: AppStrings.manageAdminUsersLabel,
            subtitle: AppStrings.manageAdminUsersDescription,
            itemClick: () {},
          ),
          customCardView(
            assetIcon: AppAssets.userIcon(),
            title: AppStrings.manageBasicUsersLabel,
            subtitle: AppStrings.manageBasicUsersDescription,
            itemClick: () {},
          ),
        ],
      ),
    );
  }

  Widget customCardView({
    required String assetIcon,
    required String title,
    required String subtitle,
    required Function itemClick,
  }) {
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
