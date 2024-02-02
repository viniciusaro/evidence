//
//  LoginSetting.swift
//
//
//  Created by Cris Messias on 02/02/24.
//

import SwiftUI

public class LoginSettingModel: ObservableObject {
    public init() {}
    func signOut() throws {
        try LoginManager.shared.signOut()
    }
}

public struct LoginSetting: View {
    @ObservedObject var viewModel: LoginSettingModel
    @Binding var isUserAuthenticated: Bool

    public var body: some View {
        List {
            Button("Log Out") {
                Task {
                    do {
                        try viewModel.signOut()
                        isUserAuthenticated = true
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    LoginSetting(viewModel: LoginSettingModel(), isUserAuthenticated: .constant(true))
}
