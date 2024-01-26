//
//  File.swift
//
//
//  Created by Cris Messias on 23/01/24.
//

import Foundation

public class LoginViewModel: ObservableObject {
    @Published var showLoginTypes: Bool
    @Published var showModalGoogle: Bool
    @Published var showModalEmail: Bool
    @Published var loginEmailViewModel: LoginEmailViewModel?

    public init(
        showLoginTypes: Bool = false,
        showModalGoogle: Bool = false,
        showModalEmail: Bool = false,
        loginEmailViewModel: LoginEmailViewModel? = nil
    ) {
        self.showLoginTypes = showLoginTypes
        self.showModalGoogle = showModalGoogle
        self.showModalEmail = showModalEmail
        self.loginEmailViewModel = loginEmailViewModel
    }

    func openModalTapped() {
        showLoginTypes = true
    }

    func buttonLoginEmailTapped() {
        loginEmailViewModel = LoginEmailViewModel() // iniciando
        loginEmailViewModel?.delegateCloseButtonTapped = {
            self.loginEmailViewModel = nil
        }
    }
}
