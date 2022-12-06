enum Status {
  active,
  inactive,
  deleted,
}

extension UtilStatus on Status {
  String get value {
    switch (this) {
      case Status.active:
        return "ACTIVE";
      case Status.inactive:
        return "INACTIVE";
      case Status.deleted:
        return "DELETED";
    }
  }
}
