import 'package:cafeysadmin/config/network.dart';
import 'package:cafeysadmin/repository/api/products_api.dart';
import 'package:cafeysadmin/repository/blocs/basic_bloc.dart';
import 'package:cafeysadmin/repository/blocs/bloc_response.dart';
import 'package:cafeysadmin/repository/interface/entity.dart';
import 'package:cafeysadmin/repository/pagination_response.dart';
import 'package:cafeysadmin/util/app_strings.dart';

class LoadUsersBloc extends BasicBloc<BlocResponse<PaginationResponse<Entity>>> {
  int _requestPage = 0;

  Future<BlocResponse<PaginationResponse<Entity>>> listProducts(String query) async {
    _requestPage = 0;
    return listMoreProducts(query);
  }

  Future<BlocResponse<PaginationResponse<Entity>>> listMoreProducts(String query) async {
    try {
      bool connected = await Network.isConnected();

      if (connected) {
        add(BlocResponse.loading());

        var response = await ProductsApi.listProducts(page: _requestPage, offset: _requestPage * 20);

        //await Future.delayed(const Duration(milliseconds: 1500));

        /*var response = ApiResponse.success(
          PaginationResponse(
            items: Mock.products(),
            currentPage: _requestPage,
            totalItems: 1000,
            totalPages: 10,
          ),
        );*/

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
