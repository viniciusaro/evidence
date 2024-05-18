//
//  LoginResetPasswordViewModel.swift
//  
//
//  Created by Cris Messias on 17/04/24.
//

import Foundation
import Dependencies

class LoginResetPasswordViewModel: ObservableObject, Identifiable {
    public var id = UUID()
    @Dependency(\.loginManager) private var loginManager
    @Dependency(\.inputValidator) private var inputValidator
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
            do {
                try await loginManager.resetPassword(email: emailInput)
            } catch {
                print("Reset Password failed!", error)
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
        if isResetPasswordButtonPressed && (emailInput.isEmpty){
            return "Email not provided."
        } else if isResetPasswordButtonPressed == true && (isValidEmail == false) {
            return "Email not valid."
        }
        return nil
    }
}
