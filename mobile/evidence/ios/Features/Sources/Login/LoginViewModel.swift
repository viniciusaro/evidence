//
//  File.swift
//
//
//  Created by Cris Messias on 23/01/24.
//

import Foundation

public class LoginViewModel: ObservableObject {
    @Published var showLoginAuth: Bool
    @Published var showAuthGoogle: Bool
    @Published var showAuthEmail: Bool
    @Published var loginEmailViewModel: LoginEmailViewModel?

    public init(
        showLoginModalConnect: Bool = false,
        showAuthGoogle: Bool = false,
        showAuthEmail: Bool = false,
        loginEmailViewModel: LoginEmailViewModel? = nil
    ) {
        self.showLoginAuth = showLoginModalConnect
        self.showAuthGoogle = showAuthGoogle
        self.showAuthEmail = showAuthEmail
        self.loginEmailViewModel = loginEmailViewModel
    }

    func buttonOpenModalTapped() {
        showLoginAuth = true
    }

    func buttonLoginEmailTapped() {
        loginEmailViewModel = LoginEmailViewModel() 
        loginEmailViewModel?.delegateCloseButtonTapped = {
            self.loginEmailViewModel = nil
        }
    }
}
