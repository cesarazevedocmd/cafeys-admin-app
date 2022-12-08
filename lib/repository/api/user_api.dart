import 'dart:convert';

import 'package:cafeysadmin/model/remove_user_dto.dart';
import 'package:cafeysadmin/model/status.dart';
import 'package:cafeysadmin/model/user.dart';
import 'package:cafeysadmin/model/user_dto.dart';
import 'package:cafeysadmin/repository/api/api_response.dart';
import 'package:cafeysadmin/repository/api/apis.dart';
import 'package:cafeysadmin/repository/pagination_response.dart';
import 'package:cafeysadmin/repository/repository.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class UserApi {
  static Future<ApiResponse<User>> add({required UserDTO dto}) async {
    RequestResult result = await Repository.postRequest(ApiUser.signUp, dto.toJson());

    switch (result.status) {
      case RequestResultStatus.success:
        Map<String, dynamic> jsonObject = json.decode(result.jsonData!);
        User user = User.fromJson(jsonObject);
        return ApiResponse.success(user);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error ?? AppStrings.requestFailed);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }

  static Future<ApiResponse<User>> update({required UserDTO dto}) async {
    RequestResult result = await Repository.putRequest(ApiUser.update, body: dto.toJson());

    switch (result.status) {
      case RequestResultStatus.success:
        Map<String, dynamic> jsonObject = json.decode(result.jsonData!);
        User user = User.fromJson(jsonObject);
        return ApiResponse.success(user);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error ?? AppStrings.requestFailed);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }

  static Future<ApiResponse<bool>> removePermanently({required RemoveUserDTO dto}) async {
    RequestResult result = await Repository.deleteRequest(ApiUser.removeUser, body: dto.toJson());

    switch (result.status) {
      case RequestResultStatus.success:
        bool jsonResult = json.decode(result.jsonData!);
        return ApiResponse.success(jsonResult);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }

  static Future<ApiResponse<bool>> active({required String id, String? annotation}) async {
    var paramsRequest = <String, dynamic>{
      "id": id,
      "annotation": annotation,
    };

    RequestResult result = await Repository.putRequest(ApiUser.activeUser, params: paramsRequest);

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

    RequestResult result = await Repository.putRequest(ApiUser.inactiveUser, params: paramsRequest);

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

    RequestResult result = await Repository.putRequest(ApiUser.deleteUser, params: paramsRequest);

    switch (result.status) {
      case RequestResultStatus.success:
        return ApiResponse.success(true);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }

  static Future<ApiResponse<User>> userInfo({required String id}) async {
    var paramsRequest = <String, dynamic>{
      "id": id,
    };

    RequestResult result = await Repository.getRequest(ApiUser.userInfo, params: paramsRequest);

    switch (result.status) {
      case RequestResultStatus.success:
        Map<String, dynamic> jsonObject = json.decode(result.jsonData!);
        User user = User.fromJson(jsonObject);
        return ApiResponse.success(user);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }

  static Future<ApiResponse<bool>> setFirebaseToken({required String userId, required String firebaseToken}) async {
    Map<String, String> paramsRequest = {
      "userId": userId,
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

  static Future<ApiResponse<CustomPaginationResponse<User>>> list({
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

    RequestResult result = await Repository.getRequest(ApiUser.list, params: paramsRequest);

    switch (result.status) {
      case RequestResultStatus.success:
        var jsonResult = json.decode(result.jsonData ?? "{}") as Map<String, dynamic>;
        List<User> items = jsonResult["items"]?.map<User>((e) => User.fromJson(e)).toList() ?? [];
        var pagination = CustomPaginationResponse.fromJson(jsonResult, items);
        return ApiResponse.success(pagination);
      case RequestResultStatus.error:
        return ApiResponse.error(result.error?.error);
      default:
        return ApiResponse.error(AppStrings.statusNotFound);
    }
  }
}
