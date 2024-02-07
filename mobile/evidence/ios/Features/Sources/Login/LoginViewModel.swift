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
    @Published var loginSettingViewModel: LoginSettingViewModel
    @Published var isUserAuthenticated: Bool

    public init(
        showLoginAuth: Bool = false,
        loginEmailViewModel: LoginEmailViewModel? = nil,
        loginSettingViewModel: LoginSettingViewModel = LoginSettingViewModel(), //source of truth
        isUserAuthenticated: Bool = false
    ) {
        self.showLoginAuthModal = showLoginAuth
        self.loginEmailViewModel = loginEmailViewModel
        self.loginSettingViewModel = loginSettingViewModel
        self.isUserAuthenticated = isUserAuthenticated
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

    func getAuthenticationUser() {
        let autheUser = try? LoginManager.shared.getAuthenticationUser()
        if autheUser == nil {
            isUserAuthenticated = true
        } 
    }
}
