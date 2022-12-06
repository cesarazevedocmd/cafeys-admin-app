import 'package:cafeysadmin/config/admin_manager.dart';
import 'package:cafeysadmin/config/nav.dart';
import 'package:cafeysadmin/custom_views/app_title_view.dart';
import 'package:cafeysadmin/custom_views/home_card_view.dart';
import 'package:cafeysadmin/page/admin_list_page.dart';
import 'package:cafeysadmin/util/app_assets.dart';
import 'package:cafeysadmin/util/app_colors.dart';
import 'package:cafeysadmin/util/app_constants.dart';
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
          HomeCardView(
            assetIcon: AppAssets.adminIcon(),
            title: AppStrings.manageAdminUsersLabel,
            subtitle: AppStrings.manageAdminUsersDescription,
            itemClick: () {
              push(context, AdminListPage());
            },
          ),
          HomeCardView(
            assetIcon: AppAssets.userIcon(),
            title: AppStrings.manageBasicUsersLabel,
            subtitle: AppStrings.manageBasicUsersDescription,
            itemClick: () {},
          ),
        ],
      ),
    );
  }
}
