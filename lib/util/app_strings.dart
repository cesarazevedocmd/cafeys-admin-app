class AppStrings {
  static const String appLabel = "Cafeys Admin";
  static const String fieldCantBeEmpty = "Campo não pode ser vazio";
  static const String notImplemented = "Não implementado";
  static const String loading = "Carregando";
  static const String empty = "";
  static const String statusNotFound = "Status não identificado";
  static const String noConnected = "Sem conexão";
  static const String requestFailed = "Requisição falhou";
  static const String loginLabel = "Login";
  static const String passwordLabel = "Senha";
  static const String passwordConfirmationLabel = "Confirmação";
  static const String loginButtonLabel = "Entrar";
  static const String blocResponseGenericError = "Algo deu errado, tente novamente";
  static const String exitLoginButtonLabel = "Remover usuário logado";
  static const String validatingAccess = "validando acesso...";
  static const String wait = "aguarde...";
  static const String hello = "Olá";
  static const String comma = ",";
  static const String nameLabel = "Nome";
  static const String emailLabel = "Email";
  static const String cancel = "Cancelar";
  static const String remove = "Remover";
  static const String updateButtonLabel = "Atualizar";
  static const String addButtonLabel = "Cadastrar";
  static const String updateAdmin = "Atualizar Administrador";
  static const String addAdmin = "Novo Administrador";
  static const String updateUser = "Atualizar Usuário";
  static const String addUser = "Novo Usuário";
  static const String tryAgain = "Tentar novamente";
  static const String noItemsFound = "Nenhum item encontrado";
  static const String itemsNotFound = "Nenhum ítem encontrado";
  static const String searchUser = "Pesquisar usuário";
  static const String selectAccessType = "Selecione o tipo de acesso";
  static const String manageAdminUsersLabel = "Usuários Administradores";
  static const String manageAdminUsersDescription = "Gerencie os usuários admistradores do sistema";
  static const String manageBasicUsersLabel = "Usuários Cafeys App";
  static const String manageBasicUsersDescription = "Gerencie os usuários que tem acesso ao Aplicativo de medição";
  static const String passwordAreNotEquals = "Senhas divergentes";
  static const String registeredUsersList = "Lista de Usuários";
  static const String registeredAdminList = "Lista de Administradores";
  static const String invalidDate = "Data invalida";
  static const String selectAccessStartDate = "Início do acesso";
  static const String selectAccessEndDate = "Fim do acesso";
  static const String userSituation = "Status";
  static const String deleteUser = "Remover Usuário";
  static const String deleteAdmin = "Remover Administrador";
  static const String userNotRemovedTryAgain = "Usuário não foi removido, tente novamente";

  static String errorMessagePasswordFieldLength(int value) {
    return "Senha deve conter mínimo de $value caracteres";
  }

  static String wouldYouLikeToRemoveThisUserPermanently(String email) {
    return "Deseja remover o usuário '$email' de forma permanente?";
  }

  static String wouldYouLikeToRemoveThisAdminPermanently(String email) {
    return "Deseja remover o administrador '$email' de forma permanente?";
  }
}
