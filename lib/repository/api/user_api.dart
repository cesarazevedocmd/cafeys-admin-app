import 'dart:convert';

import 'package:cafeysadmin/model/user.dart';
import 'package:cafeysadmin/model/user_dto.dart';
import 'package:cafeysadmin/repository/api/api_response.dart';
import 'package:cafeysadmin/repository/api/apis.dart';
import 'package:cafeysadmin/repository/pagination_response.dart';
import 'package:cafeysadmin/repository/repository.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class UserApi {
  static Future<ApiResponse<bool>> add(UserDTO dto) async {
    RequestResult result = await Repository.postRequest(ApiUser.manage, dto.toJson());

    switch (result.status) {
      case RequestResultStatus.success:
        return ApiResponse.success(true);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error ?? AppStrings.requestFailed);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }

  static Future<ApiResponse<CustomPaginationResponse<User>>> listUsers({
    required int page,
    required int size,
    String query = "",
  }) async {
    var paramsRequest = <String, dynamic>{};
    paramsRequest["page"] = "$page";
    paramsRequest["size"] = "$size";
    paramsRequest["query"] = query;

    RequestResult result = await Repository.getRequest(ApiUser.list, params: paramsRequest);

    switch (result.status) {
      case RequestResultStatus.success:
        var jsonResult = json.decode(result.jsonData ?? "{}") as Map<String, dynamic>;
        List<User> users = jsonResult["items"]?.map<User>((e) => User.fromJson(e)).toList() ?? [];
        var pagination = CustomPaginationResponse.fromJson(jsonResult, users);

        return ApiResponse.success(pagination);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }
}
