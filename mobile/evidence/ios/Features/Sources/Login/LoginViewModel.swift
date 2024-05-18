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
    @Dependency(\.loginManager) private var loginManager
    @Published var showLoginAuthModal: Bool
    @Published public var isUserNotAuthenticated: Bool
    @Published var createAccountEmail: CreateAccountEmailViewModel?
    @Published var loginEmailViewModel: LoginEmailViewModel?
    public let loginSettingViewModel:  LoginSettingViewModel

    public init(
        showLoginAuth: Bool = false,
        isUserNotAuthenticated: Bool = true,
        createAccountEmail: CreateAccountEmailViewModel? = nil,
        loginSettingViewModel: LoginSettingViewModel = LoginSettingViewModel(),
        loginEmailViewModel: LoginEmailViewModel = LoginEmailViewModel()
    ) {
        self.showLoginAuthModal = showLoginAuth
        self.isUserNotAuthenticated = isUserNotAuthenticated
        self.createAccountEmail = createAccountEmail
        self.loginSettingViewModel = loginSettingViewModel
        self.loginEmailViewModel = loginEmailViewModel

        loginSettingViewModel.delegateIsUserAuthenticated = {
            self.isUserNotAuthenticated = true
        }
    }

    func gettingStartedButtonTapped() {
        showLoginAuthModal = true
    }

    func continueWithEmailButtonTapped() {
        loginEmailViewModel = LoginEmailViewModel()
        loginEmailViewModel?.delegateCloseButtonTapped = {
            self.loginEmailViewModel = nil
        }
        loginEmailViewModel?.delegateUserAuthenticated = {
            self.isUserNotAuthenticated = false
        }
    }

    func createAccountButtonTapped() {
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
