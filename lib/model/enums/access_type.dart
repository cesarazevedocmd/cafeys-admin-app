enum AccessType { basic, admin, master }

List<AccessType> adminAccess() {
  return [AccessType.admin, AccessType.master];
}

extension AccessTypeValue on AccessType {
  String get value {
    switch (this) {
      case AccessType.basic:
        return "BASIC";
      case AccessType.admin:
        return "ADMIN";
      case AccessType.master:
        return "MASTER";
      default:
        return "BASIC";
    }
  }

  String get name {
    switch (this) {
      case AccessType.basic:
        return "Básico";
      case AccessType.admin:
        return "Admin";
      case AccessType.master:
        return "Master";
      default:
        return "Básico";
    }
  }
}

AccessType accessTypeByValue(String? value) {
  switch (value) {
    case "BASIC":
      return AccessType.basic;
    case "ADMIN":
      return AccessType.admin;
    case "MASTER":
      return AccessType.master;
    default:
      return AccessType.basic;
  }
}

AccessType accessTypeByName(String? name) {
  switch (name) {
    case "Básico":
      return AccessType.basic;
    case "Admin":
      return AccessType.admin;
    case "Master":
      return AccessType.master;
    default:
      return AccessType.basic;
  }
}
