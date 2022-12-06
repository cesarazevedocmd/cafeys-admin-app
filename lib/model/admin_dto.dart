import 'package:cafeysadmin/model/enums/access_type.dart';
import 'package:cafeysadmin/repository/interface/entity.dart';

class AdminDTO extends Entity {
  String? id;
  String? name;
  String? email;
  String? password;
  String? passwordConfirm;
  AccessType? accessType;

  AdminDTO({
    this.id,
    this.name,
    this.email,
    this.password,
    this.passwordConfirm,
    this.accessType,
  });

  AdminDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    passwordConfirm = json['passwordConfirm'];
    accessType = accessTypeByValue(json['accessType']);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['passwordConfirm'] = passwordConfirm;
    data['accessType'] = accessType?.value;
    return data;
  }
}
