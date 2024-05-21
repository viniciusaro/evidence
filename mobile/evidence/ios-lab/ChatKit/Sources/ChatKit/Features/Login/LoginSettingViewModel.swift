//
//  LoginSettingViewModel.swift
//
//
//  Created by Cris Messias on 06/02/24.
//

import AuthClient
import Foundation
import Dependencies

public class LoginSettingViewModel: ObservableObject {
    @Dependency(\.loginManager) private var loginManager
    private var singOutMessageError: String? = nil
    var delegateIsUserAuthenticated: () -> Void = { fatalError("delegateIsUserAuthenticated isn't working!") }

    public init() {}

    @MainActor
    func signOutButtonTapped() {
        Task {
            let result = loginManager.signOut()
            switch result {
            case.success(_): delegateIsUserAuthenticated()
            case.failure(let error):
            singOutMessageError = error.errorDescription
            }
        }
    }
}
