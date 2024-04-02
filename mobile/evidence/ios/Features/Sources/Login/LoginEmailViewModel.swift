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

    private func signIn() {
        Task {
            do {
                let returnUserData = try await loginManager.creatUser(email: emailInput, password: passwordInput)
                print("User created!")
                print(returnUserData)
            } catch {
                print("Error: \(error)")
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
        isValidEmail = isValidEmail(emailInput)
        isValidPassword = isValidPassword(passwordInput)

        isCreateAccountButtonPressed = true
        if isValidEmail && isValidPassword {
            signIn()
            delegateUserAuthenticated()
        }
    }

    func errorMessage() -> String? {
        if isCreateAccountButtonPressed && (emailInput.isEmpty || passwordInput.isEmpty){
            return "Email or password not provided."
        } else if isCreateAccountButtonPressed == true && (isValidEmail == false || isValidPassword == false) {
            return "Email or password not valid."
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
