//
//  LoginResetPasswordViewModel.swift
//  
//
//  Created by Cris Messias on 17/04/24.
//

import AuthClient
import Combine
import Dependencies
import Foundation

class LoginResetPasswordViewModel: ObservableObject, Identifiable {
    public var id = UUID()
    @Dependency(\.loginManager) private var loginManager
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
        isValidEmail = isValidEmail(emailInput)
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

    func isValidEmail(_ email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", options: [.caseInsensitive])
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil
    }
}
