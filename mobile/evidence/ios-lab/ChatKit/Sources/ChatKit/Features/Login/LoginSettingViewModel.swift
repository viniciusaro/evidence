//
//  LoginSettingViewModel.swift
//
//
//  Created by Cris Messias on 06/02/24.
//

import Foundation
import Dependencies
import AuthClient

public class LoginSettingViewModel: ObservableObject {
    @Dependency(\.loginManager) private var loginManager
    var delegateIsUserAuthenticated: () -> Void = { fatalError("delegateIsUserAuthenticated isn't working!") }

    public init() {}

    func signOutButtonTapped() {
        Task {
            do {
                try loginManager.signOut()
            } catch {
                print("SignOut button with error", error)
            }
        }
        delegateIsUserAuthenticated()
    }
}
