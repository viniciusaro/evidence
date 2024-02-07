//
//  LoginSettingViewModel.swift
//
//
//  Created by Cris Messias on 06/02/24.
//

import Foundation

public class LoginSettingViewModel: ObservableObject {
    public init() {}
    
    func signOut() throws {
        try LoginManager.shared.signOut()
    }

    func signOutButtonTapped() {
        Task {
            do {
                try signOut()
            } catch {
                print(error)
            }
        }
    }
}
