import 'package:cafeysadmin/config/network.dart';
import 'package:cafeysadmin/model/remove_admin_dto.dart';
import 'package:cafeysadmin/repository/api/admin_api.dart';
import 'package:cafeysadmin/repository/blocs/basic_bloc.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class RemoveAdminPermanentlyBloc extends BasicBloc<BlocResponse<bool>> {
  Future<BlocResponse<bool>> fetch({required RemoveAdminDTO dto}) async {
    try {
      bool connected = await Network.isConnected();

      if (connected) {
        add(BlocResponse.loading());

        var response = await AdminApi.removePermanently(dto: dto);

        if (response.success) {
          var blocResponse = BlocResponse.success(response.data);
          if (blocResponse.data == false) {
            blocResponse.error = AppStrings.userNotRemovedTryAgain;
          }
          return resultSuccess(blocResponse);
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
