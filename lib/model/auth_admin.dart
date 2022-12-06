class AuthAdmin {
  String? email;
  String? password;

  AuthAdmin({
    this.email,
    this.password,
  });

  AuthAdmin.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
