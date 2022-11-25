import 'dart:convert';

import 'package:cafeysadmin/model/user.dart';
import 'package:cafeysadmin/repository/api/api_response.dart';
import 'package:cafeysadmin/repository/api/apis.dart';
import 'package:cafeysadmin/repository/pagination_response.dart';
import 'package:cafeysadmin/repository/repository.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class UserApi {
  static Future<ApiResponse<CustomPaginationResponse<User>>> listUsers({
    required int page,
    required int size,
  }) async {
    var paramsRequest = <String, dynamic>{};
    paramsRequest["page"] = "$page";
    paramsRequest["size"] = "$size";

    RequestResult result = await Repository.getRequest(ApiUser.list, params: paramsRequest);

    switch (result.status) {
      case RequestResultStatus.success:
        var jsonResult = json.decode(result.jsonData ?? "{}") as Map<String, dynamic>;
        List<User> admins = jsonResult["items"].map<User>((e) => User.fromJson(e)).toList();
        var pagination = CustomPaginationResponse.fromJson(jsonResult, admins);

        return ApiResponse.success(pagination);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }
}
