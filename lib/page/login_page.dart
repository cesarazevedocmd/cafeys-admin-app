import 'package:cafeysadmin/config/admin_manager.dart';
import 'package:cafeysadmin/config/nav.dart';
import 'package:cafeysadmin/custom_views/app_button_view.dart';
import 'package:cafeysadmin/custom_views/app_text_field_view.dart';
import 'package:cafeysadmin/home_page.dart';
import 'package:cafeysadmin/model/auth_admin.dart';
import 'package:cafeysadmin/repository/blocs/auth/auth_bloc.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/util/app_assets.dart';
import 'package:cafeysadmin/util/app_functions.dart';
import 'package:cafeysadmin/util/app_space.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:cafeysadmin/util/app_toast.dart';
import 'package:cafeysadmin/util/app_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final String? email;

  const LoginPage({this.email, Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerLogin = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool visiblePassword = false;

  @override
  Widget build(BuildContext context) {
    if (widget.email != null && widget.email!.isNotEmpty && controllerLogin.text.isEmpty) {
      controllerLogin.text = widget.email!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appLabel),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: ListView(
            children: [
              AppSpace.vertical(MediaQuery.of(context).size.height / 8),
              SizedBox(height: 200, child: _logo()),
              fieldsByAuthenticatedUser(),
              AppSpace.vertical(60),
              buttonByAuthenticatedUser(),
            ],
          ),
        ),
      ),
    );
  }

  onLoginButtonClick() async {
    bool formOK = _formKey.currentState?.validate() ?? false;
    if (!formOK) {
      return;
    }

    AppWidget.showProgressDialog(context);

    String login = controllerLogin.text;
    String password = controllerPassword.text;

    var dto = AuthAdmin(email: login, password: password);

    var bloc = AuthBloc();
    var result = await bloc.fetch(login: dto);
    bloc.dispose();

    // Removing ProgressDialog from the stack
    if (mounted) pop(context);

    switch (result.status) {
      case BlocResponseStatus.unknown:
        break;
      case BlocResponseStatus.loading:
        break;
      case BlocResponseStatus.error:
        if (mounted) AppToast.error(context, result.error ?? AppStrings.blocResponseGenericError);
        break;
      case BlocResponseStatus.success:
        await AdminManager.setAdmin(result.data);
        if (mounted) _openHomeScreen();
        break;
    }
  }

  void _openHomeScreen() {
    push(context, const HomePage(), replace: true);
  }

  onExitLoginButtonClick() async {
    controllerLogin.text = "";
    controllerPassword.text = "";

    AppWidget.showProgressDialog(context);

    await AdminManager.setAdmin(null);
    await AdminManager.setPassword(null);
    await AdminManager.setToken(null);

    // Removing ProgressDialog from the stack
    if (mounted) pop(context);
  }

  Image _logo() {
    return Image.asset(
      AppAssets.logo(),
      height: 280,
    );
  }

  Widget fieldsByAuthenticatedUser() {
    return Column(
      children: [
        AppTextFieldView(
          controller: controllerLogin,
          borderType: AppTextFieldBorderType.bottom,
          label: AppStrings.loginLabel,
          validator: AppFunctions.validatorEmptyField,
        ),
        AppSpace.vertical(10),
        AppTextFieldView(
          controller: controllerPassword,
          borderType: AppTextFieldBorderType.bottom,
          label: AppStrings.passwordLabel,
          isPassword: !visiblePassword,
          maxLines: 1,
          suffixIcon: IconButton(
            icon: Icon(
              visiblePassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                visiblePassword = !visiblePassword;
              });
            },
          ),
          validator: AppFunctions.validatorEmptyField,
        )
      ],
    );
  }

  Widget buttonByAuthenticatedUser() {
    return FutureBuilder(
      initialData: null,
      future: AdminManager.getAdmin(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Row(
            children: [
              Expanded(
                child: AppButtonView(
                  text: AppStrings.loginButtonLabel,
                  textStyle: const TextStyle(fontSize: 18),
                  onClick: () => onLoginButtonClick(),
                  type: AppButtonType.primary,
                  buttonStyle: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: AppButtonView(
                text: AppStrings.exitLoginButtonLabel,
                textStyle: const TextStyle(fontSize: 18),
                onClick: () => onExitLoginButtonClick(),
                type: AppButtonType.primary,
                buttonStyle: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
