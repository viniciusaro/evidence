//
//  LoginResetPasswordViewModel.swift
//
//
//  Created by Cris Messias on 17/04/24.
//

import AuthClient
import Foundation
import Dependencies

class LoginResetPasswordViewModel: ObservableObject, Identifiable {
    public var id = UUID()
    @Dependency(\.loginManager) private var loginManager
    @Dependency(\.inputValidator) var inputValidator
    private var resetMessageError: String?
    @Published var emailInput: String
    @Published var isEmailInputFocused: Bool
    @Published private(set) var isValidEmail: Bool
    @Published var isResetPasswordButtonPressed: Bool
    var delegateCloseButtonTapped: () -> Void = { fatalError() }

    public init(
        emailInput: String = "",
        isValidEmail: Bool = false,
        isResetPasswordButtonPressed: Bool = false,
        isEmailInputFocused: Bool = false
    ) {
        self.emailInput = emailInput
        self.isValidEmail = isValidEmail
        self.isResetPasswordButtonPressed = isResetPasswordButtonPressed
        self.isEmailInputFocused = isEmailInputFocused
    }

    func closeButtonTapped() {
        delegateCloseButtonTapped()
    }

    func clearEmailInputTapped() {
        emailInput = ""
        isResetPasswordButtonPressed = false
    }

    func inputEmailTapped() {
        isResetPasswordButtonPressed = false
    }

    func resetPassword() {
        Task {
            let result = await loginManager.resetPassword(email: emailInput)
            switch result {
            case .success(_): break
            case let .failure(error):
                resetMessageError = error.errorDescription
            }
        }
    }

    func resetPasswordButtonTapped() {
        isValidEmail = inputValidator.isValidEmail(emailInput)
        isResetPasswordButtonPressed = true
        
        if isValidEmail {
            resetPassword()
            closeButtonTapped()
        }
    }

    func errorMessage() -> String? {
        if isResetPasswordButtonPressed && (emailInput.isEmpty) {
            return LoginError.emailNotProvide.errorDescription ?? nil
        } else if isResetPasswordButtonPressed && (isValidEmail == false) {
            return LoginError.invalidEmail.errorDescription ?? nil
        } else if let message = resetMessageError, isResetPasswordButtonPressed {
            return message
        }
        return nil
    }
}
