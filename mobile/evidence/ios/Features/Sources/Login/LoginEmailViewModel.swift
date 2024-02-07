//
//  LoginEmailViewModel.swift
//
//
//  Created by Cris Messias on 24/01/24.
//

import Foundation

final public class LoginEmailViewModel: ObservableObject, Identifiable {
    public var id = UUID()
    @Published var emailInput: String
    @Published var passwordInputMock: String
    @Published var isValidEmail: Bool
    @Published var isNextButtonPressed: Bool
    @Published var isEmailInputFocused: Bool
    @Published var loginCheckViewModel: LoginCheckEmailViewModel?
    var delegateCloseButtonTapped: () -> Void = { fatalError() }


    public init(
        emailInput: String = "",
        passwordInput: String = "123456",
        isValidEmail: Bool = false,
        isNextButtonPressed: Bool = false,
        isInputEmailFocused: Bool = false,
        loginCheckViewModel: LoginCheckEmailViewModel? = nil
    ) {
        self.emailInput = emailInput
        self.passwordInputMock = passwordInput
        self.isValidEmail = isValidEmail
        self.isNextButtonPressed = isNextButtonPressed
        self.isEmailInputFocused = isInputEmailFocused
        self.loginCheckViewModel = loginCheckViewModel
    }

    func signIn() {
        Task {
            do {
                let returnUserData = try await LoginManager.shared.creatUser(email: emailInput, password: passwordInputMock)
                print("Success!")
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
        isNextButtonPressed = false
    }

    func inputEmailTapped() {
        isNextButtonPressed = false
    }

    func buttonNextTapped() {
        isValidEmail = isValidEmail(emailInput)
        isNextButtonPressed = true
        if isValidEmail == true {
            signIn()
            loginCheckViewModel = LoginCheckEmailViewModel(emailInput: emailInput)
        }
    }

    func errorMessage() -> String? {
        if isNextButtonPressed && emailInput.isEmpty {
            return "No email provided."
        } else if isNextButtonPressed == true && isValidEmail == false {
            return "That doesn't look like a valid email address!"
        }
        return nil
    }

    func isValidEmail(_ email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", options: [.caseInsensitive])
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil
    }
}

