//
//  LoginEmailViewModel.swift
//
//
//  Created by Cris Messias on 24/01/24.
//

import Foundation


public class LoginEmailViewModel: ObservableObject, Identifiable {
    public var id = UUID()
    @Published var emailInput: String
    @Published var emailValid: Bool
    @Published var buttonPressed: Bool
    @Published var isFocused: Bool
    @Published var loginCheckViewModel: LoginCheckViewModel?
    var delegateCloseButtonTapped: () -> Void = { fatalError() }

    public init(
        emailInput: String = "",
        emailValid: Bool = false,
        buttonPressed: Bool = false,
        isFocused: Bool = false,
        loginCheckViewModel: LoginCheckViewModel? = nil
    ) {
        self.emailInput = emailInput
        self.emailValid = emailValid
        self.buttonPressed = buttonPressed
        self.isFocused = isFocused
        self.loginCheckViewModel = loginCheckViewModel
    }
    
    func closeButtonTapped() {
        delegateCloseButtonTapped()
    }

    func clearEmailInputTapped() {
        emailInput = ""
        buttonPressed = false
    }

    func buttonNextTapped() {
        loginCheckViewModel = LoginCheckViewModel()
        emailValid = isValidEmail(emailInput)
        buttonPressed = true
    }

    func isValidEmail(_ email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", options: [.caseInsensitive])
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil
    }
}
