import 'package:cafeysadmin/repository/interface/entity.dart';

class User extends Entity {
  String? name;
  String? email;
  String? accessStart;
  String? accessEnd;

  User({
    this.name,
    this.email,
    this.accessStart,
    this.accessEnd,
  });

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    accessStart = json['accessStart'];
    accessEnd = json['accessEnd'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['accessStart'] = accessStart;
    data['accessEnd'] = accessEnd;
    return data;
  }
}
