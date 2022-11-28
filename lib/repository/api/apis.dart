class Api {
  static const String host = "";
}

class ApiAuth {
  static const String path = "auth";
  static const String authAdmin = "$path/auth-admin";
}

class ApiAdmin {
  static const String path = "admin";
  static const String list = "$path/list";
  static const String manage = "$path/manage";
}

class ApiUser {
  static const String path = "user";
  static const String list = "$path/list";
  static const String manage = "$path/manage";
}
