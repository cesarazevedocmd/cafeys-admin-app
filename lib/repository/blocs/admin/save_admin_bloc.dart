import 'package:cafeysadmin/config/network.dart';
import 'package:cafeysadmin/model/admin.dart';
import 'package:cafeysadmin/model/admin_dto.dart';
import 'package:cafeysadmin/repository/api/admin_api.dart';
import 'package:cafeysadmin/repository/api/api_response.dart';
import 'package:cafeysadmin/repository/blocs/basic_bloc.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class SaveAdminBloc extends BasicBloc<BlocResponse<Admin>> {
  Future<BlocResponse<Admin>> fetch({required AdminDTO dto}) async {
    try {
      bool connected = await Network.isConnected();

      if (connected) {
        add(BlocResponse.loading());

        ApiResponse<Admin> response;

        if (dto.id == null || dto.id!.isEmpty) {
          response = await AdminApi.add(dto: dto);
        } else {
          response = await AdminApi.update(dto: dto);
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
