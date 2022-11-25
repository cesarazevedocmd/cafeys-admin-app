import 'package:cafeysadmin/repository/interface/entity.dart';

class PaginationResponse<T extends Entity> {
  int? currentPage = 0;
  List<T>? items;
  int? totalItems = 0;
  int? totalPages = 0;

  PaginationResponse({this.currentPage = 0, this.items, this.totalItems = 0, this.totalPages = 0});
}
