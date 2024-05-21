//
//  CreateAccountEmailViewModel.swift
//
//
//  Created by Cris Messias on 24/01/24.
//

import AuthClient
import Foundation
import Dependencies

final public class CreateAccountEmailViewModel: ObservableObject, Identifiable {
    public var id = UUID()
    var signUpMessageError: String? = nil
    @Dependency(\.loginManager) private var loginManager
    @Dependency(\.inputValidator) private var inputValidator
    private var createMessageError: String? = nil
    @Published var emailInput: String
    @Published var passwordInput: String
    @Published private(set) var isValidEmail: Bool
    @Published private(set) var isValidPassword: Bool
    @Published var isCreateAccountButtonPressed: Bool
    @Published var isEmailInputFocused: Bool
    var delegateCloseButtonTapped: () -> Void = { fatalError() }
    var delegateUserAuthenticated: () -> Void = { fatalError() }


    public init(
        emailInput: String = "",
        passwordInput: String = "",
        isValidEmail: Bool = false,
        isValidPassword: Bool = false,
        isCreateAccountButtonPressed: Bool = false,
        isInputEmailFocused: Bool = false
    ) {
        self.emailInput = emailInput
        self.passwordInput = passwordInput
        self.isValidEmail = isValidEmail
        self.isValidPassword = isValidPassword
        self.isCreateAccountButtonPressed = isCreateAccountButtonPressed
        self.isEmailInputFocused = isInputEmailFocused
    }

    private func signUp() {
        Task {
            let result = await loginManager.createUser(email: emailInput, password: passwordInput)
            switch result {
            case .success(_): break
            case let .failure(error):
                signUpMessageError = error.errorDescription
            }
        }
    }

    func closeButtonTapped() {
        delegateCloseButtonTapped()
    }

    func clearEmailInputTapped() {
        emailInput = ""
        isCreateAccountButtonPressed = false
    }

    func clearPasswordInputTapped() {
        passwordInput = ""
        isCreateAccountButtonPressed = false
    }

    func inputEmailTapped() {
        isCreateAccountButtonPressed = false
    }

    func createAccountButtonTapped() {
        isValidEmail = inputValidator.isValidEmail(emailInput)
        isValidPassword = inputValidator.isValidPassword(passwordInput)

        isCreateAccountButtonPressed = true
        if isValidEmail && isValidPassword {
            signUp()
            delegateUserAuthenticated()
        }
    }

    func errorMessage() -> String? {
        if isCreateAccountButtonPressed && (emailInput.isEmpty || passwordInput.isEmpty){
            return LoginError.credentialNotProvide.errorDescription ?? nil
        } else if let message = createMessageError, isCreateAccountButtonPressed {
            return message
        }
        return nil
    }
}

