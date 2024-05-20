//
//  LoginEmailViewModel.swift
//
//
//  Created by Cris Messias on 02/04/24.
//

import Combine
import Foundation
import Dependencies

final public class LoginEmailViewModel: ObservableObject, Identifiable {
    public var id = UUID()
    @Dependency(\.loginManager) private var loginManager
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
        emailInput: String = "",
        passwordInput: String = "",
        isValidEmail: Bool = false,
        isValidPassword: Bool = false,
        isLoginEmailButtonPressed: Bool = false,
        isEmailInputFocused: Bool = false,
        offSetY: CGFloat = 1000
    ) {
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
            do {
                _ = try await loginManager.signIn(email: emailInput, password: passwordInput)
                delegateUserAuthenticated()
            } catch {
                print(error)
            }
        }
    }

    @MainActor func loginEmailButtonTapped() {
        isValidEmail = isValidEmail(emailInput)
        isValidPassword = isValidPassword(passwordInput)

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
            return "Email or password not provided."
        } else if isLoginEmailButtonPressed == true && (isValidEmail == false || isValidPassword == false) {
            return "Email or password not valid."
        }
        return nil
    }

    func isValidEmail(_ email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", options: [.caseInsensitive])
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = #"^.{6,}$"#
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}
