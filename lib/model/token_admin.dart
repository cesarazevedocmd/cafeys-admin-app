import 'package:cafeysadmin/model/admin.dart';

class TokenAdmin {
  Admin? admin;
  String? token;

  TokenAdmin.fromJson(Map<String, dynamic> json) {
    admin = Admin.fromJson(json['admin']);
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['admin'] = admin?.toJson();
    data['token'] = token;
    return data;
  }
}
