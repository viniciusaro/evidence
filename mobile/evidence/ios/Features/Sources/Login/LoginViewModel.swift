//
//  File.swift
//
//
//  Created by Cris Messias on 23/01/24.
//

import Foundation
import FirebaseAuth
import Dependencies

final public class LoginViewModel: ObservableObject {
    @Published var showLoginAuthModal: Bool
    @Published public var isUserAuthenticated: Bool
    @Published var loginEmailViewModel: LoginEmailViewModel?
    @Published var loginSettingViewModel: LoginSettingViewModel?
    @Dependency(\.loginManager) private var loginManager

    public init(
        showLoginAuth: Bool = false,
        isUserAuthenticated: Bool = false,
        loginEmailViewModel: LoginEmailViewModel? = nil,
        loginSettingViewModel: LoginSettingViewModel? = nil
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

    func logOutButtobTapped() {
//        loginSettingViewModel = LoginSettingViewModel()
        loginSettingViewModel?.delegateIsUserAuthenticated = {
            self.isUserAuthenticated = true
        }
    }

    public func getAuthenticationUser() {
        let autheUser = try? loginManager.getAuthenticationUser()
        if autheUser == nil {
            isUserAuthenticated = true
        } 
    }
}
