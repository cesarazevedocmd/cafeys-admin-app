import 'package:cafeysadmin/repository/interface/entity.dart';

class Admin extends Entity {
  String? name;
  String? email;
  AdminType? type;

  Admin({
    this.name,
    this.email,
    this.type,
  });

  Admin.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    type = getType(json['type']);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['type'] = getValueByType(type);
    return data;
  }
}

enum AdminType { admin, master, unknown }

AdminType getType(String? value) {
  switch (value) {
    case "ADMIN":
      return AdminType.admin;
    case "MASTER":
      return AdminType.master;
    default:
      return AdminType.unknown;
  }
}

String getValueByType(AdminType? type) {
  switch (type) {
    case AdminType.admin:
      return "ADMIN";
    case AdminType.master:
      return "MASTER";
    case AdminType.unknown:
      return "UNKNOWN";
    default:
      return "UNKNOWN";
  }
}
