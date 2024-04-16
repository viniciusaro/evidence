//
//  LoginViewModel.swift
//
//
//  Created by Cris Messias on 23/01/24.
//

import Foundation
import FirebaseAuth
import Dependencies

final public class LoginViewModel: ObservableObject {
    @Published var showLoginAuthModal: Bool
    @Published public var isUserNotAuthenticated: Bool
    @Published var loginEmailViewModel: LoginEmailViewModel?
    public let loginSettingViewModel:  LoginSettingViewModel
    @Dependency(\.loginManager) private var loginManager

    public init(
        showLoginAuth: Bool = false,
        isUserNotAuthenticated: Bool = true,
        loginEmailViewModel: LoginEmailViewModel? = nil,
        loginSettingViewModel: LoginSettingViewModel = LoginSettingViewModel()
    ) {
        self.showLoginAuthModal = showLoginAuth
        self.isUserNotAuthenticated = isUserNotAuthenticated
        self.loginEmailViewModel = loginEmailViewModel
        self.loginSettingViewModel = loginSettingViewModel

        loginSettingViewModel.delegateIsUserAuthenticated = {
            self.isUserNotAuthenticated = true
        }
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

    public func getAuthenticationUser() {
        let autheUser = try? loginManager.getAuthenticationUser()
        if autheUser != nil {
            isUserNotAuthenticated = false
        }
    }
}
