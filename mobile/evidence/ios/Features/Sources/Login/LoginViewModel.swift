//
//  File.swift
//
//
//  Created by Cris Messias on 23/01/24.
//

import Foundation
import FirebaseAuth

final public class LoginViewModel: ObservableObject {
    @Published var showLoginAuthModal: Bool
    @Published var loginEmailViewModel: LoginEmailViewModel?

    public init(
        showLoginAuth: Bool = false,
        loginEmailViewModel: LoginEmailViewModel? = nil
    ) {
        self.showLoginAuthModal = showLoginAuth
        self.loginEmailViewModel = loginEmailViewModel
    }

    func gettingStartedButtonTapped() {
        showLoginAuthModal = true
    }

    func loginEmailButtonTapped() {
        loginEmailViewModel = LoginEmailViewModel()
        loginEmailViewModel?.delegateCloseButtonTapped = {
            self.loginEmailViewModel = nil
        }
    }
}
