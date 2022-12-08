import 'package:cafeysadmin/repository/interface/entity.dart';

class RemoveAdminDTO extends Entity {
  String? id;
  String? email;

  RemoveAdminDTO({required this.id, required this.email});

  RemoveAdminDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    return data;
  }
}
