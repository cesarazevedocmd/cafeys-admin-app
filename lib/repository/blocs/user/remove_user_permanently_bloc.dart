import 'package:cafeysadmin/config/network.dart';
import 'package:cafeysadmin/model/remove_user_dto.dart';
import 'package:cafeysadmin/repository/api/user_api.dart';
import 'package:cafeysadmin/repository/blocs/basic_bloc.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class RemoveUserPermanentlyBloc extends BasicBloc<BlocResponse<bool>> {
  Future<BlocResponse<bool>> fetch({required RemoveUserDTO dto}) async {
    try {
      bool connected = await Network.isConnected();

      if (connected) {
        add(BlocResponse.loading());

        var response = await UserApi.removePermanently(dto: dto);

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
