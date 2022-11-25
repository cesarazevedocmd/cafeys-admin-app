import 'dart:convert';

import 'package:cafeysadmin/repository/api/api_response.dart';
import 'package:cafeysadmin/repository/api/apis.dart';
import 'package:cafeysadmin/repository/interface/entity.dart';
import 'package:cafeysadmin/repository/pagination_response.dart';
import 'package:cafeysadmin/repository/repository.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class ProductsApi {
  static Future<ApiResponse<PaginationResponse<Entity>>> listProducts({required int page, required int offset}) async {
    var paramsRequest = <String, dynamic>{};
    paramsRequest["description_html"] = 1;
    paramsRequest["offset"] = offset;

    RequestResult result = await Repository.getRequest(ApiProducts.list, params: paramsRequest);

    switch (result.status) {
      case RequestResultStatus.success:
        var jsonResult = json.decode(result.jsonData ?? "{}") as Map<String, dynamic>;
        //var receivedItem = IntegratedStoreItem.fromJson(jsonResult);

        //var totalPages = (receivedItem.meta?.next != null) ? page + 1 : page;

        var pagination = PaginationResponse(
          currentPage: page,
          items: <Entity>[],
          totalItems: 0,
          totalPages: 0,
        );

        return ApiResponse.success(pagination);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }
}
