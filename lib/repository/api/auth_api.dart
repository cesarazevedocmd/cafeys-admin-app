import 'dart:convert';

import 'package:cafeysadmin/model/auth_admin.dart';
import 'package:cafeysadmin/model/token_admin.dart';
import 'package:cafeysadmin/repository/api/api_response.dart';
import 'package:cafeysadmin/repository/api/apis.dart';
import 'package:cafeysadmin/repository/repository.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class AuthApi {
  static Future<ApiResponse<TokenAdmin>> auth(AuthAdmin login) async {
    try {
      RequestResult result = await Repository.postRequest(
        ApiAuth.authAdmin,
        login.toJson(),
        sendToken: false,
      );

      switch (result.status) {
        case RequestResultStatus.success:
          Map<String, dynamic> jsonObject = json.decode(result.jsonData!);
          return ApiResponse.success(TokenAdmin.fromJson(jsonObject));
        case RequestResultStatus.error:
          return ApiResponse.error(result.error?.error ?? AppStrings.requestFailed);
        default:
          return ApiResponse.error(AppStrings.statusNotFound);
      }
    } catch (exception) {
      return ApiResponse.error(exception.toString());
    }
  }
}
