import 'package:cafeysadmin/config/admin_manager.dart';
import 'package:cafeysadmin/config/nav.dart';
import 'package:cafeysadmin/home_page.dart';
import 'package:cafeysadmin/model/auth_admin.dart';
import 'package:cafeysadmin/page/login_page.dart';
import 'package:cafeysadmin/repository/blocs/auth/auth_bloc.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/util/app_assets.dart';
import 'package:cafeysadmin/util/app_constants.dart';
import 'package:cafeysadmin/util/app_space.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:cafeysadmin/util/app_toast.dart';
import 'package:cafeysadmin/util/app_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  String loadingText = AppStrings.wait;

  @override
  void initState() {
    super.initState();
    initValidation();
  }

  void initValidation() {
    Future.wait([
      AdminManager.getEmail(),
      AdminManager.getPassword(),
      //AppFirebaseRemoteConfig.fetch(),
    ]).then(
      (values) {
        String? email = values[0];
        String? password = values[1];
        //Api.host = AppFirebaseRemoteConfig.getHostUrl() ?? AppStrings.empty;
        //Api.hostPublicValue = AppFirebaseRemoteConfig.getHostPublicValue();
        if (email.isNotEmpty && password.isNotEmpty) {
          _performLogin(email, password);
        } else {
          _openLoginScreen(email);
        }
      },
    ).onError((error, stackTrace) {
      if (kDebugMode) {
        print("SPLASH ERROR $stackTrace");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: AppConstants.VALUE_0),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.VALUE_20),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: AppConstants.VALUE_500),
              child: Image.asset(AppAssets.logo()),
            ),
            AppSpace.vertical(AppConstants.VALUE_30),
            AppWidget.loading(text: loadingText),
          ],
        ),
      ),
    );
  }

  void _performLogin(String email, String password) async {
    setState(() => loadingText = AppStrings.validatingAccess);

    var dto = AuthAdmin(email: email, password: password);

    var bloc = AuthBloc();
    var result = await bloc.fetch(login: dto);
    bloc.dispose();

    switch (result.status) {
      case BlocResponseStatus.unknown:
        break;
      case BlocResponseStatus.loading:
        break;
      case BlocResponseStatus.error:
        if (mounted) {
          AppToast.error(context, result.error ?? AppStrings.blocResponseGenericError);
        }
        break;
      case BlocResponseStatus.success:
        await AdminManager.setAdmin(result.data);
        if (mounted) _openHomeScreen();
        break;
    }
  }

  void _openLoginScreen(String email) {
    push(context, LoginPage(email: email), replace: true);
  }

  void _openHomeScreen() {
    push(context, const HomePage(), replace: true);
  }
}
