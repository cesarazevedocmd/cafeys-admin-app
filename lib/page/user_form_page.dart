import 'package:cafeysadmin/config/nav.dart';
import 'package:cafeysadmin/custom_views/app_button_view.dart';
import 'package:cafeysadmin/custom_views/app_date_picker_view.dart';
import 'package:cafeysadmin/custom_views/app_text_field_view.dart';
import 'package:cafeysadmin/model/user.dart';
import 'package:cafeysadmin/model/user_dto.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/repository/blocs/user/save_user_bloc.dart';
import 'package:cafeysadmin/util/app_constants.dart';
import 'package:cafeysadmin/util/app_space.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:cafeysadmin/util/app_toast.dart';
import 'package:cafeysadmin/util/app_validation.dart';
import 'package:cafeysadmin/util/app_widget.dart';
import 'package:flutter/material.dart';

class UserFormPage extends StatefulWidget {
  final User? user;

  const UserFormPage({this.user, Key? key}) : super(key: key);

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool loadedFields = false;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerPasswordConfirmation = TextEditingController();
  bool visiblePassword = false;
  bool visiblePasswordConfirmation = false;
  DateTime? accessStart;
  DateTime? accessEnd;

  @override
  Widget build(BuildContext context) {
    loadFields(widget.user);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user != null ? AppStrings.updateUser : AppStrings.addUser),
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
          validator: widget.user != null ? null : AppValidation.passwordMinimumCharacter,
          enable: widget.user == null,
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
          validator: widget.user != null ? null : _validateConfirmationPassword,
          enable: widget.user == null,
        ),
        AppSpace.vertical(AppConstants.VALUE_10),
        AppDatePickerView(
          dateWhenOpenDialog: DateTime.now(),
          initialValue: accessStart,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: AppConstants.VALUE_365.toInt())),
          hintSelectDate: AppStrings.selectAccessStartDate,
          removeButtonText: AppStrings.selectAccessStartDate,
          onSelectedDate: (DateTime? selectedDate) {
            accessStart = selectedDate;
          },
        ),
        AppSpace.vertical(AppConstants.VALUE_10),
        AppDatePickerView(
          dateWhenOpenDialog: DateTime.now(),
          initialValue: accessEnd,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: AppConstants.VALUE_365.toInt())),
          hintSelectDate: AppStrings.selectAccessEndDate,
          removeButtonText: AppStrings.selectAccessEndDate,
          onSelectedDate: (DateTime? selectedDate) {
            accessEnd = selectedDate;
          },
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
            text: widget.user != null ? AppStrings.updateButtonLabel : AppStrings.addButtonLabel,
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

  void loadFields(User? user) {
    if (user != null && !loadedFields) {
      controllerName.text = user.name!;
      controllerEmail.text = user.email!;
      accessStart = user.accessStart;
      accessEnd = user.accessEnd;
      loadedFields = true;
    }
  }

  void onLoginButtonClick() async {
    bool formOK = _formKey.currentState?.validate() ?? false;
    if (!formOK) {
      return;
    }

    AppWidget.showProgressDialog(context);

    var dto = UserDTO(
      id: widget.user?.id,
      name: controllerName.text,
      email: controllerEmail.text,
      password: controllerPassword.text,
      passwordConfirm: controllerPasswordConfirmation.text,
      accessStart: accessStart,
      accessEnd: accessEnd,
    );

    var bloc = SaveUserBloc();
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
