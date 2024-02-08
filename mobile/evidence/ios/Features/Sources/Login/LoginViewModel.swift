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
    @Published var isUserAuthenticated: Bool
    @Published var loginEmailViewModel: LoginEmailViewModel?
    @Published var loginSettingViewModel: LoginSettingViewModel

    public init(
        showLoginAuth: Bool = false,
        isUserAuthenticated: Bool = false,
        loginEmailViewModel: LoginEmailViewModel? = nil,
        loginSettingViewModel: LoginSettingViewModel
    ) {
        self.showLoginAuthModal = showLoginAuth
        self.isUserAuthenticated = isUserAuthenticated
        self.loginEmailViewModel = loginEmailViewModel
        self.loginSettingViewModel = loginSettingViewModel 
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

    func getAuthenticationUser(loginManager: LoginManager) {
        let autheUser = try? loginManager.getAuthenticationUser()
        if autheUser == nil {
            isUserAuthenticated = true
        } 
    }
}
