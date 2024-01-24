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
    @Published var passwordInput: String
    @Published var isPasswordSecure: Bool
    var delegateCloseButtonTapped: () -> Void = { fatalError() }

    public init(emailInput: String = "", passwordInput: String = "", showPasswordInput: Bool = false) {
        self.emailInput = emailInput
        self.passwordInput = passwordInput
        self.isPasswordSecure = showPasswordInput
    }
    
    func closeButtonTapped() {
        delegateCloseButtonTapped()
    }

    func clearEmailInputTapped() {
        emailInput = ""
    }

    func isPasswordSecureTapped() {
        isPasswordSecure.toggle()
    }
}
