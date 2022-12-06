import 'package:cafeysadmin/config/nav.dart';
import 'package:cafeysadmin/custom_views/app_button_view.dart';
import 'package:cafeysadmin/custom_views/app_drop_down_view.dart';
import 'package:cafeysadmin/custom_views/app_text_field_view.dart';
import 'package:cafeysadmin/model/admin.dart';
import 'package:cafeysadmin/model/admin_dto.dart';
import 'package:cafeysadmin/model/enums/access_type.dart';
import 'package:cafeysadmin/repository/blocs/admin/save_admin_bloc.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/util/app_constants.dart';
import 'package:cafeysadmin/util/app_space.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:cafeysadmin/util/app_toast.dart';
import 'package:cafeysadmin/util/app_validation.dart';
import 'package:cafeysadmin/util/app_widget.dart';
import 'package:flutter/material.dart';

class AdminFormPage extends StatefulWidget {
  final Admin? admin;

  const AdminFormPage({this.admin, Key? key}) : super(key: key);

  @override
  State<AdminFormPage> createState() => _AdminFormPageState();
}

class _AdminFormPageState extends State<AdminFormPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerPasswordConfirmation = TextEditingController();
  AccessType? selectedAccessType;
  bool visiblePassword = false;
  bool visiblePasswordConfirmation = false;

  @override
  Widget build(BuildContext context) {
    loadFields(widget.admin);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.admin != null ? AppStrings.updateAdmin : AppStrings.addAdmin),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.only(left: AppConstants.VALUE_16, right: AppConstants.VALUE_16),
          child: ListView(
            children: [
              AppSpace.vertical(MediaQuery.of(context).size.height / AppConstants.VALUE_8.toInt()),
              fieldsByAuthenticatedUser(),
              AppSpace.vertical(AppConstants.VALUE_60),
              saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldsByAuthenticatedUser() {
    return Column(
      children: [
        AppTextFieldView(
          controller: controllerName,
          borderType: AppTextFieldBorderType.bottom,
          label: AppStrings.nameLabel,
          validator: AppValidation.validatorEmptyField,
        ),
        AppSpace.vertical(AppConstants.VALUE_10),
        AppTextFieldView(
          controller: controllerEmail,
          borderType: AppTextFieldBorderType.bottom,
          label: AppStrings.emailLabel,
          validator: AppValidation.validatorEmptyField,
        ),
        AppSpace.vertical(AppConstants.VALUE_10),
        AppDropDownView<String>(
          initialValue: selectedAccessType?.name,
          items: adminAccess().map((e) => e.name).toList(),
          hint: AppStrings.selectAccessType,
          onSelectedItem: (value) {
            selectedAccessType = accessTypeByName(value);
          },
        ),
        AppSpace.vertical(AppConstants.VALUE_10),
        AppTextFieldView(
          controller: controllerPassword,
          borderType: AppTextFieldBorderType.bottom,
          label: AppStrings.passwordLabel,
          isPassword: !visiblePassword,
          maxLines: AppConstants.VALUE_1.toInt(),
          suffixIcon: IconButton(
            icon: Icon(visiblePassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                visiblePassword = !visiblePassword;
              });
            },
          ),
          validator: AppValidation.passwordMinimumCharacter,
        ),
        AppSpace.vertical(AppConstants.VALUE_10),
        AppTextFieldView(
          controller: controllerPasswordConfirmation,
          borderType: AppTextFieldBorderType.bottom,
          label: AppStrings.passwordConfirmationLabel,
          isPassword: !visiblePasswordConfirmation,
          maxLines: AppConstants.VALUE_1.toInt(),
          suffixIcon: IconButton(
            icon: Icon(visiblePasswordConfirmation ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                visiblePasswordConfirmation = !visiblePasswordConfirmation;
              });
            },
          ),
          validator: _validateConfirmationPassword,
        ),
        AppSpace.vertical(AppConstants.VALUE_10),
      ],
    );
  }

  String? _validateConfirmationPassword(String? value) {
    var validation = AppValidation.passwordMinimumCharacter(value);
    if (validation == null) {
      if (controllerPassword.text != controllerPasswordConfirmation.text) {
        return AppStrings.passwordAreNotEquals;
      }
    }
    return validation;
  }

  Widget saveButton() {
    return Row(
      children: [
        Expanded(
          child: AppButtonView(
            text: widget.admin != null ? AppStrings.updateButtonLabel : AppStrings.addButtonLabel,
            textStyle: const TextStyle(fontSize: AppConstants.VALUE_18),
            onClick: () => onLoginButtonClick(),
            type: AppButtonType.primary,
            buttonStyle: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.VALUE_8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void loadFields(Admin? admin) {
    if (admin != null) {
      controllerName.text = admin.name!;
      controllerEmail.text = admin.email!;
      selectedAccessType = admin.accessType;
    }
  }

  void onLoginButtonClick() async {
    bool formOK = _formKey.currentState?.validate() ?? false;
    if (!formOK) {
      return;
    }

    if (selectedAccessType == null) {
      AppToast.error(context, AppStrings.selectAccessType);
      return;
    }

    AppWidget.showProgressDialog(context);

    String name = controllerName.text;
    String email = controllerEmail.text;
    String password = controllerPassword.text;
    String passwordConfirmation = controllerPasswordConfirmation.text;

    var dto = AdminDTO(
      id: widget.admin?.id,
      name: name,
      email: email,
      password: password,
      passwordConfirm: passwordConfirmation,
      accessType: selectedAccessType,
    );

    var bloc = SaveAdminBloc();
    var result = await bloc.fetch(dto: dto);
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
        if (mounted) pop(context, result: true);
        break;
    }
  }
}
