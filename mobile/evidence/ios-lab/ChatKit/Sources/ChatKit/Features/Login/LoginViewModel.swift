//
//  LoginView.swift
//
//
//  Created by Cris Messias on 23/01/24.
//

import Foundation
import Dependencies

final public class LoginViewModel: ObservableObject {
    @Dependency(\.loginManager) private var loginManager
    private var autheticationMessageError: String? = nil
    @Published var showLoginAuthModal: Bool
    @Published var createAccountEmail: CreateAccountEmailViewModel?
    @Published var loginEmailViewModel: LoginEmailViewModel?
    public let loginSettingViewModel:  LoginSettingViewModel
    var delegateUserAuthenticated: () -> Void = { fatalError() }

    public init(
        showLoginAuth: Bool = false,
        createAccountEmail: CreateAccountEmailViewModel? = nil,
        loginSettingViewModel: LoginSettingViewModel = LoginSettingViewModel(),
        loginEmailViewModel: LoginEmailViewModel = LoginEmailViewModel()
    ) {
        self.showLoginAuthModal = showLoginAuth
        self.createAccountEmail = createAccountEmail
        self.loginSettingViewModel = loginSettingViewModel
        self.loginEmailViewModel = loginEmailViewModel
    }

    func gettingStartedButtonTapped() {
        showLoginAuthModal = true
    }

    func continueWithEmailButtonTapped() {
        loginEmailViewModel = LoginEmailViewModel()
        loginEmailViewModel?.delegateCloseButtonTapped = {
            self.loginEmailViewModel = nil
        }
        loginEmailViewModel?.delegateUserAuthenticated = self.delegateUserAuthenticated
    }

    func createAccountButtonTapped() {
        createAccountEmail = CreateAccountEmailViewModel()
        createAccountEmail?.delegateCloseButtonTapped = {
            self.createAccountEmail = nil
        }
        createAccountEmail?.delegateUserAuthenticated = self.delegateUserAuthenticated
    }
}
