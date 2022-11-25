import 'dart:convert';

import 'package:cafeysadmin/model/admin.dart';
import 'package:cafeysadmin/repository/api/api_response.dart';
import 'package:cafeysadmin/repository/api/apis.dart';
import 'package:cafeysadmin/repository/pagination_response.dart';
import 'package:cafeysadmin/repository/repository.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class AdminApi {
  static Future<ApiResponse<CustomPaginationResponse<Admin>>> listAdmins({
    required int page,
    required int size,
  }) async {
    var paramsRequest = <String, dynamic>{};
    paramsRequest["page"] = "$page";
    paramsRequest["size"] = "$size";

    RequestResult result = await Repository.getRequest(ApiAdmin.list, params: paramsRequest);

    switch (result.status) {
      case RequestResultStatus.success:
        var jsonResult = json.decode(result.jsonData ?? "{}") as Map<String, dynamic>;
        List<Admin> admins = jsonResult["items"].map<Admin>((e) => Admin.fromJson(e)).toList();
        var pagination = CustomPaginationResponse.fromJson(jsonResult, admins);

        return ApiResponse.success(pagination);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }
}
