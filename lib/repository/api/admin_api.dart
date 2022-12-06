import 'dart:convert';

import 'package:cafeysadmin/model/admin.dart';
import 'package:cafeysadmin/model/admin_dto.dart';
import 'package:cafeysadmin/model/status.dart';
import 'package:cafeysadmin/repository/api/api_response.dart';
import 'package:cafeysadmin/repository/api/apis.dart';
import 'package:cafeysadmin/repository/pagination_response.dart';
import 'package:cafeysadmin/repository/repository.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class AdminApi {
  static Future<ApiResponse<Admin>> add({required AdminDTO dto}) async {
    RequestResult result = await Repository.postRequest(ApiAdmin.signUp, dto.toJson());

    switch (result.status) {
      case RequestResultStatus.success:
        Map<String, dynamic> jsonObject = json.decode(result.jsonData!);
        Admin admin = Admin.fromJson(jsonObject);
        return ApiResponse.success(admin);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error ?? AppStrings.requestFailed);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }

  static Future<ApiResponse<Admin>> update({required AdminDTO dto}) async {
    RequestResult result = await Repository.putRequest(ApiAdmin.update, body: dto.toJson());

    switch (result.status) {
      case RequestResultStatus.success:
        Map<String, dynamic> jsonObject = json.decode(result.jsonData!);
        Admin admin = Admin.fromJson(jsonObject);
        return ApiResponse.success(admin);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error ?? AppStrings.requestFailed);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }

  static Future<ApiResponse<bool>> active({required String id, String? annotation}) async {
    var paramsRequest = <String, dynamic>{
      "id": id,
      "annotation": annotation,
    };

    RequestResult result = await Repository.putRequest(ApiAdmin.activeAdmin, params: paramsRequest);

    switch (result.status) {
      case RequestResultStatus.success:
        return ApiResponse.success(true);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }

  static Future<ApiResponse<bool>> inactive({required String id, String? annotation}) async {
    var paramsRequest = <String, dynamic>{
      "id": id,
      "annotation": annotation,
    };

    RequestResult result = await Repository.putRequest(ApiAdmin.inactiveAdmin, params: paramsRequest);

    switch (result.status) {
      case RequestResultStatus.success:
        return ApiResponse.success(true);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }

  static Future<ApiResponse<bool>> delete({required String id, String? annotation}) async {
    var paramsRequest = <String, dynamic>{
      "id": id,
      "annotation": annotation,
    };

    RequestResult result = await Repository.putRequest(ApiAdmin.deleteAdmin, params: paramsRequest);

    switch (result.status) {
      case RequestResultStatus.success:
        return ApiResponse.success(true);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }

  static Future<ApiResponse<Admin>> adminInfo({required String id}) async {
    var paramsRequest = <String, dynamic>{
      "id": id,
    };

    RequestResult result = await Repository.getRequest(ApiAdmin.adminInfo, params: paramsRequest);

    switch (result.status) {
      case RequestResultStatus.success:
        Map<String, dynamic> jsonObject = json.decode(result.jsonData!);
        Admin admin = Admin.fromJson(jsonObject);
        return ApiResponse.success(admin);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }

  static Future<ApiResponse<bool>> setFirebaseToken({required String adminId, required String firebaseToken}) async {
    Map<String, String> paramsRequest = {
      "adminId": adminId,
      "firebaseToken": firebaseToken,
    };

    RequestResult result = await Repository.putRequest(ApiUser.setFirebaseToken, params: paramsRequest);

    switch (result.status) {
      case RequestResultStatus.success:
        bool resultValue = json.decode(result.jsonData!);
        return ApiResponse.success(resultValue);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }

  static Future<ApiResponse<CustomPaginationResponse<Admin>>> list({
    required int page,
    required int size,
    String query = "",
    Status? status,
  }) async {
    var paramsRequest = <String, dynamic>{
      "page": "$page",
      "size": "$size",
      "query": query,
      "status": status?.value,
    };

    RequestResult result = await Repository.getRequest(ApiAdmin.list, params: paramsRequest);

    switch (result.status) {
      case RequestResultStatus.success:
        var jsonResult = json.decode(result.jsonData ?? "{}") as Map<String, dynamic>;
        List<Admin> items = jsonResult["items"]?.map<Admin>((e) => Admin.fromJson(e)).toList() ?? [];
        var pagination = CustomPaginationResponse.fromJson(jsonResult, items);
        return ApiResponse.success(pagination);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }
}
