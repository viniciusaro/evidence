import '../presentation/login_presentation.gen.dart';

class LoginStateHidden extends LoginState {
  @override
  bool get errorMessageHidden => true;
}

class LoginStateRegular extends LoginState {
  @override
  bool get errorMessageRegular => true;
}

class LoginStateLoading extends LoginState {
  @override
  bool get submitButtonLoading => true;
}

class LoginStateError extends LoginState {
  @override
  bool get submitButtonError => true;
}

class LoginStateDisabled extends LoginState {
  @override
  bool get usernameInputDisabled => true;

  @override
  bool get passwordInputDisabled => true;
}

class LoginStateEnabled extends LoginState {}
