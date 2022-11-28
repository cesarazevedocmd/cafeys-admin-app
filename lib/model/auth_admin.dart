class AuthAdmin {
  String? login;
  String? password;

  AuthAdmin({
    this.login,
    this.password,
  });

  AuthAdmin.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login'] = login;
    data['password'] = password;
    return data;
  }
}
