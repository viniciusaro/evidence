//
//  LoginEmailViewModel.swift
//
//
//  Created by Cris Messias on 02/04/24.
//

import AuthClient
import Foundation
import Dependencies

final public class LoginEmailViewModel: ObservableObject, Identifiable {
    public var id = UUID()
    @Dependency(\.loginManager) private var loginManager
    @Dependency(\.inputValidator) private var inputValidator
    private var signInMessageError: String?
    @Published var emailInput: String
    @Published var passwordInput: String
    @Published private(set) var isValidEmail: Bool
    @Published private(set) var isValidPassword: Bool
    @Published var isLoginEmailButtonPressed: Bool
    @Published var isEmailInputFocused: Bool
    @Published var loginResetPassword: LoginResetPasswordViewModel?
    @Published private(set) var alertOffSetY: CGFloat
    var delegateCloseButtonTapped: () -> Void = { fatalError() }
    var delegateUserAuthenticated: () -> Void = { fatalError() }

    public init(
        signInMessageError: String? = nil,
        emailInput: String = "",
        passwordInput: String = "",
        isValidEmail: Bool = false,
        isValidPassword: Bool = false,
        isLoginEmailButtonPressed: Bool = false,
        isEmailInputFocused: Bool = false,
        offSetY: CGFloat = 1000
    ) {
        self.signInMessageError = signInMessageError
        self.emailInput = emailInput
        self.passwordInput = passwordInput
        self.isValidEmail = isValidEmail
        self.isValidPassword = isValidPassword
        self.isLoginEmailButtonPressed = isLoginEmailButtonPressed
        self.isEmailInputFocused = isEmailInputFocused
        self.alertOffSetY = offSetY
    }

    func confirmationPopupAppears() {
        alertOffSetY = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.alertOffSetY = 1000
        }
    }

    func closeButtonTapped() {
        delegateCloseButtonTapped()
    }

    func clearEmailInputTapped() {
        emailInput = ""
        isLoginEmailButtonPressed = false
    }

    func clearPasswordInputTapped() {
        passwordInput = ""
        isLoginEmailButtonPressed = false
    }

    func inputEmailTapped() {
        isLoginEmailButtonPressed = false
    }
    
    @MainActor func signIn() {
        Task {
            let result = await loginManager.signIn(email: emailInput, password: passwordInput)
            switch result {
            case .success(_):  delegateUserAuthenticated()
            case let .failure(error):
                signInMessageError = error.errorDescription
            }

        }
    }

    @MainActor func loginEmailButtonTapped() {
        isValidEmail = inputValidator.isValidEmail(emailInput)
        isValidPassword = inputValidator.isValidPassword(passwordInput)

        isLoginEmailButtonPressed = true
        if isValidEmail && isValidPassword {
            signIn()
        }
    }

    func resetPassworButtonTapped() {
        loginResetPassword = LoginResetPasswordViewModel()
        loginResetPassword?.delegateCloseButtonTapped = {
            self.loginResetPassword = nil
            self.confirmationPopupAppears()
        }
    }

    func errorMessage() -> String? {
        if isLoginEmailButtonPressed && (emailInput.isEmpty || passwordInput.isEmpty){
            return LoginError.credentialNotProvide.errorDescription ?? nil
        } else if let message = signInMessageError, isLoginEmailButtonPressed {
            return message
        }
        return nil
    }
}

