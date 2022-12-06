import 'package:cafeysadmin/config/nav.dart';
import 'package:cafeysadmin/custom_views/home_card_view.dart';
import 'package:cafeysadmin/page/admin_list_page.dart';
import 'package:cafeysadmin/page/user_list_page.dart';
import 'package:cafeysadmin/util/app_assets.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:cafeysadmin/util/app_widget.dart';
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
      appBar: AppWidget.helloAdminAppBar(),
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
            itemClick: () {
              push(context, UserListPage());
            },
          ),
        ],
      ),
    );
  }
}
