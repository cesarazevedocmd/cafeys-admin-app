import 'package:cafeysadmin/config/nav.dart';
import 'package:cafeysadmin/custom_views/app_button_view.dart';
import 'package:cafeysadmin/custom_views/app_date_picker_view.dart';
import 'package:cafeysadmin/custom_views/app_subtitle_view.dart';
import 'package:cafeysadmin/custom_views/app_text_field_view.dart';
import 'package:cafeysadmin/custom_views/app_title_view.dart';
import 'package:cafeysadmin/model/remove_user_dto.dart';
import 'package:cafeysadmin/model/status.dart';
import 'package:cafeysadmin/model/user.dart';
import 'package:cafeysadmin/model/user_dto.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/repository/blocs/user/remove_user_permanently_bloc.dart';
import 'package:cafeysadmin/repository/blocs/user/save_user_bloc.dart';
import 'package:cafeysadmin/util/app_colors.dart';
import 'package:cafeysadmin/util/app_constants.dart';
import 'package:cafeysadmin/util/app_functions.dart';
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
  Status selectedStatus = Status.active;
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
              AppSpace.vertical(AppConstants.VALUE_10),
              fieldsByAuthenticatedUser(),
              AppSpace.vertical(AppConstants.VALUE_20),
              saveButton(),
              AppSpace.vertical(AppConstants.VALUE_10),
              removeButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldsByAuthenticatedUser() {
    var startDateToAccessEnd = (accessStart ?? AppFunctions.now()).add(Duration(days: AppConstants.VALUE_1.toInt()));
    DateTime safeInitialDateToAccessStart = AppFunctions.now();
    if (widget.user?.accessStart?.isBefore(AppFunctions.now()) == true) {
      safeInitialDateToAccessStart = widget.user!.accessStart!;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          dateWhenOpenDialog: accessStart ?? AppFunctions.now(),
          initialValue: accessStart,
          firstDate: safeInitialDateToAccessStart,
          lastDate: AppFunctions.now().add(Duration(days: AppConstants.VALUE_365.toInt())),
          useFirstDateWhenInitialDateIsOutOfRange: true,
          hintSelectDate: AppStrings.selectAccessStartDate,
          removeButtonText: AppStrings.selectAccessStartDate,
          onSelectedDate: (DateTime? selectedDate) {
            setState(() {
              accessStart = selectedDate;
              accessEnd = null;
            });
          },
        ),
        AppSpace.vertical(AppConstants.VALUE_10),
        AppDatePickerView(
          dateWhenOpenDialog: startDateToAccessEnd,
          initialValue: accessEnd,
          firstDate: startDateToAccessEnd,
          lastDate: startDateToAccessEnd.add(Duration(days: AppConstants.VALUE_365.toInt())),
          hintSelectDate: AppStrings.selectAccessEndDate,
          removeButtonText: AppStrings.selectAccessEndDate,
          onSelectedDate: (DateTime? selectedDate) {
            accessEnd = selectedDate;
          },
        ),
        AppSpace.vertical(AppConstants.VALUE_10),
        const AppTitleView(
          text: AppStrings.userSituation,
          color: AppColors.black,
          bold: false,
          textSize: AppConstants.VALUE_16,
        ),
        ListTile(
          title: Text(Status.active.name),
          leading: Radio<Status>(
            value: Status.active,
            groupValue: selectedStatus,
            onChanged: (Status? value) {
              setState(() => selectedStatus = value ?? Status.active);
            },
          ),
          onTap: () => setState(() => selectedStatus = Status.active),
        ),
        ListTile(
          title: Text(Status.inactive.name),
          leading: Radio<Status>(
            value: Status.inactive,
            groupValue: selectedStatus,
            onChanged: (Status? value) {
              setState(() => selectedStatus = value ?? Status.inactive);
            },
          ),
          onTap: () => setState(() => selectedStatus = Status.inactive),
        ),
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
          ),
        ),
      ],
    );
  }

  Widget removeButton() {
    if (widget.user == null) return AppWidget.empty();

    return Row(
      children: [
        Expanded(
          child: AppButtonView(
            text: AppStrings.deleteUser,
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

  void loadFields(User? user) {
    if (user != null && !loadedFields) {
      controllerName.text = user.name!;
      controllerEmail.text = user.email!;
      accessStart = user.accessStart;
      accessEnd = user.accessEnd;
      loadedFields = true;
      selectedStatus = user.status ?? Status.active;
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
      status: selectedStatus,
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

  Future<void> onRemovePermanentlyButtonClick() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.person_remove),
          title: const AppTitleView(
            text: AppStrings.deleteUser,
            color: AppColors.black,
          ),
          content: AppSubtitleView(
            text: AppStrings.wouldYouLikeToRemoveThisUserPermanently(widget.user?.email ?? AppStrings.empty),
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

    var dto = RemoveUserDTO(
      id: widget.user?.id,
      email: widget.user?.email,
    );

    var bloc = RemoveUserPermanentlyBloc();
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
