//
//  LoginSetting.swift
//
//
//  Created by Cris Messias on 02/02/24.
//

import SwiftUI
import Leaf

public struct LoginSetting: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginSettingViewModel
    @Binding var isUserAuthenticated: Bool


    public var body: some View {
        List {
            Button("Log Out") {
                viewModel.signOutButtonTapped()
                isUserAuthenticated = true
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    LoginSetting(viewModel: LoginSettingViewModel(), isUserAuthenticated: .constant(true))
}
