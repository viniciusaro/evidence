//
//  LoginSettingViewModel.swift
//
//
//  Created by Cris Messias on 06/02/24.
//

import Foundation

public class LoginSettingViewModel: ObservableObject {
    public init() {}

    func signOut(loginManager: LoginManager) throws {
        try loginManager.signOut()
    }

    func signOutButtonTapped(loginManager: LoginManager) {
        Task {
            do {
                try signOut(loginManager: loginManager)
            } catch {
                print(error)
            }
        }
    }
}
