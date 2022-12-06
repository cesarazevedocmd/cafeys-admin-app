import 'package:cafeysadmin/config/network.dart';
import 'package:cafeysadmin/model/admin.dart';
import 'package:cafeysadmin/repository/api/admin_api.dart';
import 'package:cafeysadmin/repository/blocs/basic_bloc.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class AdminInfoBloc extends BasicBloc<BlocResponse<Admin>> {
  Future<BlocResponse<Admin>> fetch({required String id}) async {
    try {
      bool connected = await Network.isConnected();

      if (connected) {
        add(BlocResponse.loading());

        var response = await AdminApi.adminInfo(id: id);

        if (response.success) {
          return resultSuccess(BlocResponse.success(response.data));
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
}
