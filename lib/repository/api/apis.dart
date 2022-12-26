class Api {
  static String host = "";
  static String hostPublicValue = "";
}

class ApiAuth {
  static const String _path = "/auth";
  static const String authAdmin = "$_path/admin";
  static const String adminRefreshToken = "$_path/admin-refresh-token";
  static const String authUser = "$_path/user";
  static const String userRefreshToken = "$_path/user-refresh-token";
}

class ApiAdmin {
  static const String path = "/admin";
  static const String activeAdmin = "$path/active-admin";
  static const String deleteAdmin = "$path/delete-admin";
  static const String removeAdmin = "$path/remove-admin";
  static const String inactiveAdmin = "$path/inactive-admin";
  static const String adminInfo = "$path/admin-info";
  static const String list = "$path/list";
  static const String setFirebaseToken = "$path/set-firebase-token";
  static const String signUp = "$path/sign-up";
  static const String update = "$path/update";
}

class ApiUser {
  static const String path = "/user";
  static const String activeUser = "$path/active-user";
  static const String deleteUser = "$path/delete-user";
  static const String removeUser = "$path/remove-user";
  static const String inactiveUser = "$path/inactive-user";
  static const String userInfo = "$path/user-info";
  static const String list = "$path/list";
  static const String setFirebaseToken = "$path/set-firebase-token";
  static const String signUp = "$path/sign-up";
  static const String update = "$path/update";
}
