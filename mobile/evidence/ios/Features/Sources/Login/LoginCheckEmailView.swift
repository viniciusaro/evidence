//
//  LoginCheckView.swift
//
//
//  Created by Cris Messias on 26/01/24.
//

import SwiftUI
import Leaf

public struct LoginCheckEmailView: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginCheckEmailViewModel

    public init(viewModel: LoginCheckEmailViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            Divider()
            VStack(spacing: 24) {
                Message(viewModel: viewModel)
                Spacer()
                OpenEmailAppButton()
            }
            .padding([.leading, .trailing], 16)
            .navigationTitle("Email Sent")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LoginCheckEmailView(viewModel: LoginCheckEmailViewModel())
        .previewCustomFonts()
}

struct Message: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginCheckEmailViewModel

    var body: some View {
        VStack(spacing: 8) {
            Text("Check your email!")
                .title()
            Text("To confirm your email address, tap the button in the email we sent to **\(viewModel.mockEmail)**")
                .body()
        }
    }
}

struct OpenEmailAppButton: View {
    @Environment(\.leafTheme) private var theme
    var body: some View {
        Button("Open Email App") {

        }
        .buttonStyle(LeafPrimaryButton())
        .padding(24)
    }
}
