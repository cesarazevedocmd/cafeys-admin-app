import 'package:cafeysadmin/util/app_constants.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class AppValidation {
  static String? validatorEmptyField(String? value) {
    String valueString = value ?? "";
    if (valueString.isEmpty) {
      return AppStrings.fieldCantBeEmpty;
    }
    return null;
  }

  static String? passwordMinimumCharacter(String? value) {
    if (value == null || value.isEmpty) return AppStrings.fieldCantBeEmpty;
    if (value.length < AppConstants.PASSWORD_MIN_LENGTH) {
      return AppStrings.errorMessagePasswordFieldLength(AppConstants.PASSWORD_MIN_LENGTH);
    }
    return null;
  }
}
