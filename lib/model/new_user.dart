import 'package:cafeysadmin/repository/interface/entity.dart';

class NewUser extends Entity {
  String? name;
  String? email;
  String? password;
  String? passwordConfirm;
  String? accessStart;
  String? accessEnd;

  NewUser({
    this.name,
    this.email,
    this.password,
    this.passwordConfirm,
    this.accessStart,
    this.accessEnd,
  });

  NewUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    passwordConfirm = json['passwordConfirm'];
    accessStart = json['accessStart'];
    accessEnd = json['accessEnd'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['passwordConfirm'] = passwordConfirm;
    data['accessStart'] = accessStart;
    data['accessEnd'] = accessEnd;
    return data;
  }
}
