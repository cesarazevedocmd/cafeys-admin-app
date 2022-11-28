import 'package:cafeysadmin/repository/interface/entity.dart';

class UserDTO extends Entity {
  String? id;
  String? name;
  String? email;
  String? password;
  String? passwordConfirm;
  DateTime? accessStart;
  DateTime? accessEnd;

  UserDTO({
    this.id,
    this.name,
    this.email,
    this.password,
    this.passwordConfirm,
    this.accessStart,
    this.accessEnd,
  });

  UserDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    passwordConfirm = json['passwordConfirm'];
    accessStart = json['accessStart'] != null ? DateTime.tryParse(json['accessStart']) : null;
    accessEnd = json['accessEnd'] != null ? DateTime.tryParse(json['accessEnd']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['passwordConfirm'] = passwordConfirm;
    data['accessStart'] = accessStart?.toIso8601String();
    data['accessEnd'] = accessEnd?.toIso8601String();
    return data;
  }
}
