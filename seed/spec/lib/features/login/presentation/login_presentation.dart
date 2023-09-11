import 'package:spec/core.dart';

import '../interaction/login_interaction.dart';

enum LoginElements {
  usernameInput,
  passwordInput,
  submitButton,
  errorMessage,
}

class LoginPresentation with Presentation<LoginElements, LoginInteractions> {
  @override
  List<LoginElements> get elements => LoginElements.values;

  @override
  Map<(PresentationActionType, LoginElements), LoginInteractions> get actions => {
        (PresentationActionType.tap, LoginElements.submitButton): LoginInteractions.authenticate,
      };

  @override
  Map<(LoginInteractions, PresentationActionLifecycle), PresentationActionType> get interactions => {
        (LoginInteractions.authenticate, PresentationActionLifecycle.start): PresentationActionType.load,
        (LoginInteractions.authenticate, PresentationActionLifecycle.end): PresentationActionType.loaded,
      };

  @override
  Map<(PresentationActionType, LoginElements), PresentationStateType> get states => {
        (PresentationActionType.loaded, LoginElements.errorMessage): PresentationStateType.hidden,
        (PresentationActionType.error, LoginElements.errorMessage): PresentationStateType.regular,
        (PresentationActionType.load, LoginElements.submitButton): PresentationStateType.loading,
        (PresentationActionType.error, LoginElements.submitButton): PresentationStateType.error,
        (PresentationActionType.load, LoginElements.usernameInput): PresentationStateType.disabled,
        (PresentationActionType.load, LoginElements.passwordInput): PresentationStateType.disabled,
      };
}
