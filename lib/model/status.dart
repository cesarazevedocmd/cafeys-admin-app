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

  String get name {
    switch (this) {
      case Status.active:
        return "Ativo";
      case Status.inactive:
        return "Inativo";
      case Status.deleted:
        return "Removido";
      default:
        return "Ativo";
    }
  }
}

Status statusByValue(String? value) {
  switch (value) {
    case "ACTIVE":
      return Status.active;
    case "INACTIVE":
      return Status.inactive;
    case "DELETED":
      return Status.deleted;
    default:
      return Status.active;
  }
}

Status statusByName(String? name) {
  switch (name) {
    case "Ativo":
      return Status.active;
    case "Inativo":
      return Status.inactive;
    case "Removido":
      return Status.deleted;
    default:
      return Status.active;
  }
}
