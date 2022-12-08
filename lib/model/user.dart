import 'package:cafeysadmin/model/status.dart';
import 'package:cafeysadmin/repository/interface/entity.dart';

class User extends Entity {
  String? id;
  String? name;
  String? email;
  DateTime? accessStart;
  DateTime? accessEnd;
  Status? status;

  User({
    this.id,
    this.name,
    this.email,
    this.accessStart,
    this.accessEnd,
    this.status,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    accessStart = json['accessStart'] != null ? DateTime.tryParse(json['accessStart']) : null;
    accessEnd = json['accessEnd'] != null ? DateTime.tryParse(json['accessEnd']) : null;
    status = statusByValue(json["status"]);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['accessStart'] = accessStart?.toIso8601String();
    data['accessEnd'] = accessEnd?.toIso8601String();
    data["status"] = status?.value;
    return data;
  }
}
