import 'package:cafeysadmin/repository/interface/entity.dart';

class CustomPaginationResponse<T extends Entity> {
  int? currentPage = 0;
  List<T>? items;
  int? totalItems = 0;
  int? totalPages = 0;

  CustomPaginationResponse({this.currentPage = 0, this.items, this.totalItems = 0, this.totalPages = 0});

  CustomPaginationResponse.fromJson(Map<String, dynamic> json, List<T> this.items) {
    this.currentPage = json['currentPage'];
    this.totalItems = json['totalItems'];
    this.totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPage'] = this.currentPage;
    data['items'] = this.items?.map((v) => v.toJson()).toList() ?? [];
    data['totalItems'] = this.totalItems;
    data['totalPages'] = this.totalPages;
    return data;
  }
}
