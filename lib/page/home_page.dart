import 'package:cafeysadmin/config/admin_manager.dart';
import 'package:cafeysadmin/config/nav.dart';
import 'package:cafeysadmin/custom_views/app_subtitle_view.dart';
import 'package:cafeysadmin/custom_views/home_card_view.dart';
import 'package:cafeysadmin/page/admin_list_page.dart';
import 'package:cafeysadmin/page/login_page.dart';
import 'package:cafeysadmin/page/user_list_page.dart';
import 'package:cafeysadmin/util/app_assets.dart';
import 'package:cafeysadmin/util/app_colors.dart';
import 'package:cafeysadmin/util/app_constants.dart';
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
      appBar: AppWidget.helloAdminAppBar(actions: getActions()),
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

  List<Widget> getActions() {
    return [
      IconButton(
        onPressed: () => askToExit(),
        icon: const Icon(Icons.exit_to_app),
      ),
    ];
  }

  Future<void> askToExit() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: AppSubtitleView(
            text: AppStrings.wouldYouLikeToLogoutQuestion,
            color: AppColors.black,
            maxLines: AppConstants.VALUE_5.toInt(),
          ),
          actions: [
            TextButton(
              onPressed: () => pop(context),
              child: const Text(
                AppStrings.cancel,
                style: TextStyle(color: AppColors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                pop(context);
                performLogout();
              },
              child: const Text(
                AppStrings.logout,
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> performLogout() async {
    await AdminManager.removeAdmin();
    await AdminManager.removePassword();
    await AdminManager.removeToken();
    if (mounted) {
      push(context, const LoginPage(), replace: true);
    }
  }
}
