import 'package:cafeysadmin/model/admin.dart';
import 'package:cafeysadmin/repository/interface/entity.dart';

class NewAdmin extends Entity {
  String? name;
  String? email;
  String? password;
  String? passwordConfirm;
  AdminType? type;

  NewAdmin({
    this.name,
    this.email,
    this.password,
    this.passwordConfirm,
    this.type,
  });

  NewAdmin.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    passwordConfirm = json['passwordConfirm'];
    type = getType(json['type']);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['passwordConfirm'] = passwordConfirm;
    data['type'] = getValueByType(type);
    return data;
  }
}
