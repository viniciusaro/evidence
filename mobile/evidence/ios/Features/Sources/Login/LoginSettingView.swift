//
//  LoginSettingView.swift
//
//
//  Created by Cris Messias on 02/02/24.
//

import SwiftUI
import Leaf

public struct LoginSettingView: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginSettingViewModel
    
    public init(viewModel: LoginSettingViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        List {
            Button("Log Out") {
                viewModel.signOutButtonTapped()
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    LoginSettingView(viewModel: LoginSettingViewModel())
}

