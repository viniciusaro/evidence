//
//  LoginEmailViewModel.swift
//
//
//  Created by Cris Messias on 02/04/24.
//

import Foundation
import Dependencies

final public class LoginEmailViewModel: ObservableObject, Identifiable {
    public var id = UUID()
    @Dependency(\.loginManager) private var loginManager
    @Published var emailInput: String
    @Published var passwordInput: String
    var signInMessageError: String? = nil
    @Published private(set) var isValidEmail: Bool
    @Published private(set) var isValidPassword: Bool
    @Published var isLoginEmailButtonPressed: Bool
    @Published var isEmailInputFocused: Bool
    @Published var loginResetPassword: LoginResetPasswordViewModel?
    @Published private(set) var AlertOffSetY: CGFloat
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
        self.AlertOffSetY = offSetY
    }

    func confirmationPopupAppears() {
        AlertOffSetY = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.AlertOffSetY = 1000
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

    @MainActor 
    func loginEmailButtonTapped() {
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
            return LoginError.emailOrPasswordNotProvide.errorDescription ?? nil
        } else if let message = signInMessageError, isLoginEmailButtonPressed == true {
            return message
        }
        return nil
    }

    func isValidEmail(_ email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", options: [.caseInsensitive])
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = #"^.{8,}$"#
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}
