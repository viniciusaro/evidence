//
//  LoginSettingViewModel.swift
//
//
//  Created by Cris Messias on 06/02/24.
//

import Foundation
import Dependencies

public class LoginSettingViewModel: ObservableObject {
    @Dependency(\.loginManager) private var loginManager
    var delegateIsUserAuthenticated: () -> Void = { fatalError("delegateIsUserAuthenticated isn't working!") }

    public init() {}

    private func signOut() throws {
        try loginManager.signOut()
    }

    func signOutButtonTapped() {
        Task {
            do {
                try signOut()
            } catch {
                print("SignOut button with error", error)
            }
        }
        delegateIsUserAuthenticated()
    }
}
