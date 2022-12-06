import 'package:cafeysadmin/model/enums/access_type.dart';
import 'package:cafeysadmin/repository/interface/entity.dart';

class Admin extends Entity {
  String? id;
  String? name;
  String? email;
  AccessType? accessType;

  Admin({
    this.id,
    this.name,
    this.email,
    this.accessType,
  });

  Admin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    accessType = accessTypeByValue(json['accessType']);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['accessType'] = accessType?.value;
    return data;
  }
}
