import 'package:spec/core.dart';

import '../flutter/login_state.dart';

// gen
abstract class LoginState {
  bool get errorMessageHidden => false;
  bool get errorMessageRegular => false;
  bool get submitButtonLoading => false;
  bool get submitButtonError => false;
  bool get usernameInputDisabled => false;
  bool get passwordInputDisabled => false;
}

class LoginStateGenerator {
  LoginState generate(PresentationStateType state) {
    switch (state) {
      case PresentationStateType.regular:
        return LoginStateRegular();
      case PresentationStateType.loading:
        return LoginStateLoading();
      case PresentationStateType.error:
        return LoginStateError();
      case PresentationStateType.disabled:
        return LoginStateDisabled();
      case PresentationStateType.enabled:
        return LoginStateEnabled();
      case PresentationStateType.hidden:
        return LoginStateHidden();
    }
  }
}
