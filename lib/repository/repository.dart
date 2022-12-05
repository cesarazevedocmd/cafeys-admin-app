import 'dart:convert';
import 'dart:io';

import 'package:cafeysadmin/config/user_manager.dart';
import 'package:cafeysadmin/repository/api/apis.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RequestResult {
  late RequestResultStatus status;
  RequestErrorResponse? error;
  String? jsonData;

  RequestResult.success(this.jsonData) {
    status = RequestResultStatus.success;
  }

  RequestResult.error(this.error) {
    status = RequestResultStatus.error;
  }
}

class RequestErrorResponse {
  String? status;
  int? code;
  String? error;

  RequestErrorResponse({this.status, this.code, this.error});

  RequestErrorResponse.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString() ?? AppStrings.empty;
    code = json['code'] ?? json['status'] ?? AppStrings.empty;
    error = json['message'] ?? json['error'] ?? AppStrings.empty;
    if (status == "403") error = "Não autorizado";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = error;
    return data;
  }
}

class ResponseStatusCode {
  static const int success = 200;
  static const int successCreated = 201;
}

enum RequestResultStatus {
  success,
  error,
}

class Repository {
  static Future<RequestResult> getRequest(
    String url, {
    Map<String, dynamic>? params,
    bool sendToken = true,
  }) async {
    try {
      String queryParamsString = "";

      if (params != null) queryParamsString = "?${Uri(queryParameters: params).query}";

      Uri uri = Uri.parse("${Api.host}$url$queryParamsString");

      var header = await _getHeader(sendToken);

      http.Response response = await http.get(uri, headers: header);

      _printRequest(uri, response);

      return _convertResponse(response);
    } catch (ex) {
      _printErrorRequest(url, ex);
      return RequestResult.error(_genericError(ex));
    }
  }

  static Future<RequestResult> deleteRequest(
    String url, {
    Map<String, String>? params,
    Map? body,
    bool sendToken = true,
  }) async {
    try {
      String queryParamsString = "";

      if (params != null) queryParamsString = "?${Uri(queryParameters: params).query}";

      Uri uri = Uri.parse("${Api.host}$url$queryParamsString");

      var header = await _getHeader(sendToken);

      http.Response response = await http.delete(uri, headers: header, body: body);

      _printRequest(uri, response);

      return _convertResponse(response);
    } catch (ex) {
      _printErrorRequest(url, ex);
      return RequestResult.error(_genericError(ex));
    }
  }

  static Future<RequestResult> postRequest(
    String url,
    Map body, {
    bool sendToken = true,
  }) async {
    try {
      Uri uri = Uri.parse("${Api.host}$url");

      var header = await _getHeader(sendToken);

      String bodyEncoded = json.encode(body);

      http.Response response = await http.post(uri, headers: header, body: bodyEncoded);

      _printRequest(uri, response);

      return _convertResponse(response);
    } catch (ex) {
      _printErrorRequest(url, ex);
      return RequestResult.error(_genericError(ex));
    }
  }

  static Future<RequestResult> putRequest(
    String url, {
    Map? body,
    Map<String, dynamic>? params,
    bool sendToken = true,
  }) async {
    try {
      String queryParamsString = "";

      if (params != null) queryParamsString = "?${Uri(queryParameters: params).query}";

      Uri uri = Uri.parse("${Api.host}$url$queryParamsString");

      var header = await _getHeader(sendToken);

      String bodyEncoded = json.encode(body);

      http.Response response = await http.put(uri, headers: header, body: bodyEncoded);

      _printRequest(uri, response);

      return _convertResponse(response);
    } catch (ex) {
      _printErrorRequest(url, ex);
      return RequestResult.error(_genericError(ex));
    }
  }

  /*static Future<RequestResult> refreshToken(String url) async {
    try {
      Uri uri = Uri.parse("${Api.host}$url");

      var header = await _getHeader(true);
      header["isRefreshToken"] = "true";

      http.Response response = await http.get(uri, headers: header);

      printRequest(uri, response);

      return convertResponse(response);
    } catch (ex) {
      printErrorRequest(url, ex);
      return RequestResult.error(_genericError(ex));
    }
  }*/

  /*static Future<RequestResult> postNewUserRequest(String url, Map user, File photo) async {
    try {
      Uri uri = Uri.parse("${Api.host}$url");

      http.MultipartRequest request = http.MultipartRequest("POST", uri);
      request.headers["pub-key"] = Api.hostPublicValue;
      request.fields["user"] = json.encode(user);

      var tempFile = await http.MultipartFile.fromPath("photo", photo.path, filename: basename(photo.path));
      request.files.add(tempFile);

      http.StreamedResponse responseSend = await request.send();

      http.Response response = await http.Response.fromStream(responseSend);

      printRequest(uri, response);

      return convertResponse(response);
    } catch (ex) {
      printErrorRequest(url, ex);
      return RequestResult.error(_genericError(ex));
    }
  }*/

  /*static Future<RequestResult> uploadFilesHttp(String url, String fileType, List<File> files, {bool sendToken = true}) async {
    try {
      Uri uri = Uri.parse("${Api.host}$url");

      http.MultipartRequest request = http.MultipartRequest("POST", uri);
      if (sendToken == true) request.headers["Authorization"] = await _getToken();
      request.headers["pub-key"] = Api.hostPublicValue;
      request.fields["fileType"] = fileType;

      for (int i = 0; i < files.length; i++) {
        File file = files[i];
        var tempFile = await http.MultipartFile.fromPath("files", file.path, filename: basename(file.path));
        request.files.add(tempFile);
      }

      http.StreamedResponse responseSend = await request.send();

      http.Response response = await http.Response.fromStream(responseSend);

      printRequest(uri, response);

      return convertResponse(response);
    } catch (ex) {
      printErrorRequest(url, ex);
      return RequestResult.error(_genericError(ex));
    }
  }*/

  /*static Future<RequestResult> uploadFileHttp(String url, String fileType, File file, {bool sendToken = true}) async {
    try {
      Uri uri = Uri.parse("${Api.host}$url");

      http.MultipartRequest request = http.MultipartRequest("POST", uri);
      if (sendToken == true) request.headers["Authorization"] = await _getToken();
      request.headers["pub-key"] = Api.hostPublicValue;
      request.fields["fileType"] = fileType;

      var tempFile = await http.MultipartFile.fromPath("file", file.path, filename: basename(file.path));
      request.files.add(tempFile);

      http.StreamedResponse responseSend = await request.send();

      http.Response response = await http.Response.fromStream(responseSend);

      printRequest(uri, response);

      return convertResponse(response);
    } catch (ex) {
      printErrorRequest(url, ex);
      return RequestResult.error(_genericError(ex));
    }
  }*/

  /*static String _generateQueryParam({Map<String, dynamic>? params}) {
    if (params != null) {
      for (var key in params.keys) {
        params[key] = params[key].toString();
      }
    }
    Map<String, dynamic> paramsTemp = params ?? <String, dynamic>{};
    paramsTemp["format"] = "json";

    return "?${Uri(queryParameters: paramsTemp).query}";
  }*/

  static RequestResult _convertResponse(http.Response response) {
    switch (response.statusCode) {
      case ResponseStatusCode.success:
      case ResponseStatusCode.successCreated:
        var decodedResult = utf8.decode(response.bodyBytes);
        return RequestResult.success(decodedResult);
      default:
        return RequestResult.error(_error(response));
    }
  }

  static Future<Map<String, String>> _getHeader(bool sendToken) async {
    final token = await UserManager.getToken();
    var headers = {
      "Content-Type": "application/json; charset=utf-8",
      "pub-key": Api.hostPublicValue,
    };
    if (sendToken == true) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  static Future<String> _getBearerToken() async {
    final token = await UserManager.getToken();
    return "Bearer $token";
  }

  static RequestErrorResponse _error(http.Response response) {
    try {
      String jsonError = utf8.decode(response.bodyBytes);
      var result = json.decode(jsonError);
      return RequestErrorResponse.fromJson(result);
    } catch (ex) {
      try {
        var result = json.decode(response.body);
        return RequestErrorResponse.fromJson(result);
      } catch (ex2) {
        return RequestErrorResponse(error: ex.toString());
      }
    }
  }

  static RequestErrorResponse _genericError(ex) {
    if (ex is SocketException) return RequestErrorResponse(error: "Falha de conexão");
    return RequestErrorResponse(error: ex.toString());
  }

  static void _printRequest(Uri uri, http.Response response) {
    if (kDebugMode) {
      print("REQUEST: $uri");
      print("RESPONSE CODE: ${response.statusCode}");
      print("RESPONSE: ${response.body}");
      print("**TO DISABLE PRINT REQUEST, CHANGE 'showRequest' variable**");
    }
  }

  static void _printErrorRequest(String url, ex) {
    if (kDebugMode) {
      print("REQUEST ERROR: $url");
      print("ERROR: ${ex.toString()}");
    }
  }
}
