import 'package:cafeysadmin/config/admin_manager.dart';
import 'package:cafeysadmin/config/network.dart';
import 'package:cafeysadmin/model/admin.dart';
import 'package:cafeysadmin/model/auth_admin.dart';
import 'package:cafeysadmin/model/token_admin.dart';
import 'package:cafeysadmin/repository/api/api_response.dart';
import 'package:cafeysadmin/repository/api/auth_api.dart';
import 'package:cafeysadmin/repository/blocs/basic_bloc.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:flutter/foundation.dart';

class AuthBloc extends BasicBloc<BlocResponse<Admin>> {
  Future<BlocResponse<Admin>> fetch({required AuthAdmin login}) async {
    try {
      bool connected = await Network.isConnected();

      if (connected) {
        add(BlocResponse.loading());

        ApiResponse<TokenAdmin> response = await AuthApi.auth(login);

        if (response.success) {
          String token = response.data!.token!;
          Admin admin = response.data!.admin!;

          await AdminManager.setAdmin(admin);
          await AdminManager.setToken(token);
          await AdminManager.setPassword(login.password);
          await validateFirebaseToken(admin);

          return resultSuccess(BlocResponse.success(admin));
        } else {
          return resultError(BlocResponse.error(response.error));
        }
      } else {
        return resultError(BlocResponse.error(AppStrings.noConnected));
      }
    } catch (error) {
      return resultError(BlocResponse.error(error.toString()));
    }
  }

  Future<void> validateFirebaseToken(Admin user) async {
    try {
      //String? firebaseToken = await FirebaseMessaging.instance.getToken();
      //if (firebaseToken != null && firebaseToken.isNotEmpty) await AdminApi.setFirebaseToken(user.id, firebaseToken);
    } catch (ex) {
      if (kDebugMode) {
        print("ERROR GET FIREBASE TOKEN: ${ex.toString()}");
      }
    }
  }
}
