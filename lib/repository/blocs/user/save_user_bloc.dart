import 'package:cafeysadmin/config/network.dart';
import 'package:cafeysadmin/model/user.dart';
import 'package:cafeysadmin/model/user_dto.dart';
import 'package:cafeysadmin/repository/api/api_response.dart';
import 'package:cafeysadmin/repository/api/user_api.dart';
import 'package:cafeysadmin/repository/blocs/basic_bloc.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class SaveUserBloc extends BasicBloc<BlocResponse<User>> {
  Future<BlocResponse<User>> fetch({required UserDTO dto}) async {
    try {
      bool connected = await Network.isConnected();

      if (connected) {
        add(BlocResponse.loading());

        ApiResponse<User> response;

        if (dto.id == null || dto.id!.isEmpty) {
          response = await UserApi.add(dto: dto);
        } else {
          response = await UserApi.update(dto: dto);
        }

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
