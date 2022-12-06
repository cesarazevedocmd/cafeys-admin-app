import 'package:cafeysadmin/config/network.dart';
import 'package:cafeysadmin/model/user.dart';
import 'package:cafeysadmin/repository/api/user_api.dart';
import 'package:cafeysadmin/repository/blocs/basic_bloc.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/repository/pagination_response.dart';
import 'package:cafeysadmin/util/app_constants.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class ListUserBloc extends BasicBloc<BlocResponse<CustomPaginationResponse<User>>> {
  int _requestPage = 0;

  Future<BlocResponse<CustomPaginationResponse<User>>> fetch({String query = ""}) async {
    _requestPage = 0;
    return fetchMore(query: query);
  }

  Future<BlocResponse<CustomPaginationResponse<User>>> fetchMore({String query = ""}) async {
    try {
      bool connected = await Network.isConnected();

      if (connected) {
        add(BlocResponse.loading());

        var response = await UserApi.list(
          page: _requestPage,
          size: AppConstants.DEFAULT_PAGE_SIZE,
          query: query,
        );

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
