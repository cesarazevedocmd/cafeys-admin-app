import 'package:cafeysadmin/config/nav.dart';
import 'package:cafeysadmin/custom_views/app_button_view.dart';
import 'package:cafeysadmin/custom_views/app_drop_down_view.dart';
import 'package:cafeysadmin/custom_views/app_subtitle_view.dart';
import 'package:cafeysadmin/custom_views/app_text_field_view.dart';
import 'package:cafeysadmin/custom_views/app_title_view.dart';
import 'package:cafeysadmin/model/admin.dart';
import 'package:cafeysadmin/model/admin_dto.dart';
import 'package:cafeysadmin/model/enums/access_type.dart';
import 'package:cafeysadmin/model/remove_admin_dto.dart';
import 'package:cafeysadmin/repository/blocs/admin/remove_admin_permanently_bloc.dart';
import 'package:cafeysadmin/repository/blocs/admin/save_admin_bloc.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/util/app_colors.dart';
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
  bool loadedFields = false;
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
              AppSpace.vertical(AppConstants.VALUE_10),
              fieldsByAuthenticatedAdmin(),
              AppSpace.vertical(AppConstants.VALUE_60),
              saveButton(),
              AppSpace.vertical(AppConstants.VALUE_10),
              removeButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldsByAuthenticatedAdmin() {
    return Column(
      children: [
        AppTextFieldView(
          controller: controllerName,
          borderType: AppTextFieldBorderType.bottom,
          label: AppStrings.nameLabel,
          inputType: TextInputType.name,
          validator: AppValidation.validatorEmptyField,
        ),
        AppSpace.vertical(AppConstants.VALUE_10),
        AppTextFieldView(
          controller: controllerEmail,
          borderType: AppTextFieldBorderType.bottom,
          label: AppStrings.emailLabel,
          inputType: TextInputType.emailAddress,
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
          validator: widget.admin != null ? null : AppValidation.passwordMinimumCharacter,
          enable: widget.admin == null,
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
          validator: widget.admin != null ? null : _validateConfirmationPassword,
          enable: widget.admin == null,
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
          ),
        ),
      ],
    );
  }

  Widget removeButton() {
    if (widget.admin == null) return AppWidget.empty();

    return Row(
      children: [
        Expanded(
          child: AppButtonView(
            text: AppStrings.deleteAdmin,
            textStyle: const TextStyle(fontSize: AppConstants.VALUE_18, color: AppColors.darkRed),
            onClick: () => onRemovePermanentlyButtonClick(),
            type: AppButtonType.secondary,
            icon: const Icon(
              Icons.person_remove,
              color: AppColors.darkRed,
            ),
          ),
        ),
      ],
    );
  }

  void loadFields(Admin? admin) {
    if (admin != null && !loadedFields) {
      controllerName.text = admin.name!;
      controllerEmail.text = admin.email!;
      selectedAccessType = admin.accessType;
      loadedFields = true;
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

  Future<void> onRemovePermanentlyButtonClick() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.person_remove),
          title: const AppTitleView(
            text: AppStrings.deleteAdmin,
            color: AppColors.black,
          ),
          content: AppSubtitleView(
            text: AppStrings.wouldYouLikeToRemoveThisAdminPermanently(widget.admin?.email ?? AppStrings.empty),
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
                removePermanently();
              },
              child: const Text(
                AppStrings.remove,
                style: TextStyle(color: AppColors.darkRed),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> removePermanently() async {
    bool formOK = _formKey.currentState?.validate() ?? false;
    if (!formOK) {
      return;
    }

    AppWidget.showProgressDialog(context);

    var dto = RemoveAdminDTO(
      id: widget.admin?.id,
      email: widget.admin?.email,
    );

    var bloc = RemoveAdminPermanentlyBloc();
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
        if (mounted) {
          if (result.data == true) {
            pop(context, result: true);
          } else {
            AppToast.error(context, result.error ?? AppStrings.blocResponseGenericError);
          }
        }
        break;
    }
  }
}
