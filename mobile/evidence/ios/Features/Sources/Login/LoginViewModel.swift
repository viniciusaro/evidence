//
//  LoginView.swift
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
    @Published var createAccountEmail: CreateAccountEmailViewModel?
    public let loginSettingViewModel:  LoginSettingViewModel
    @Dependency(\.loginManager) private var loginManager

    public init(
        showLoginAuth: Bool = false,
        isUserNotAuthenticated: Bool = true,
        loginEmailViewModel: CreateAccountEmailViewModel? = nil,
        loginSettingViewModel: LoginSettingViewModel = LoginSettingViewModel()
    ) {
        self.showLoginAuthModal = showLoginAuth
        self.isUserNotAuthenticated = isUserNotAuthenticated
        self.createAccountEmail = loginEmailViewModel
        self.loginSettingViewModel = loginSettingViewModel

        loginSettingViewModel.delegateIsUserAuthenticated = {
            self.isUserNotAuthenticated = true
        }
    }

    func gettingStartedButtonTapped() {
        showLoginAuthModal = true
    }

    func loginEmailButtonTapped() {
        createAccountEmail = CreateAccountEmailViewModel()
        createAccountEmail?.delegateCloseButtonTapped = {
            self.createAccountEmail = nil
        }
        createAccountEmail?.delegateUserAuthenticated = {
            self.isUserNotAuthenticated = false
        }
    }

    public func getAuthenticationUser() {
        let autheUser = try? loginManager.getAuthenticationUser()
        if autheUser != nil {
            isUserNotAuthenticated = false
        }
    }
}
