import 'package:cafeysadmin/config/network.dart';
import 'package:cafeysadmin/model/user.dart';
import 'package:cafeysadmin/repository/api/user_api.dart';
import 'package:cafeysadmin/repository/blocs/basic_bloc.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/repository/pagination_response.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class ListUsersBloc extends BasicBloc<BlocResponse<CustomPaginationResponse<User>>> {
  int _requestPage = 0;

  Future<BlocResponse<CustomPaginationResponse<User>>> listUsers({String query = ""}) async {
    _requestPage = 0;
    return listMoreUsers(query: query);
  }

  Future<BlocResponse<CustomPaginationResponse<User>>> listMoreUsers({String query = ""}) async {
    try {
      bool connected = await Network.isConnected();

      if (connected) {
        add(BlocResponse.loading());

        var response = await UserApi.listUsers(page: _requestPage, size: _requestPage * 20, query: query);

        if (response.success) {
          _requestPage += 1;
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
