//
//  LoginCheckView.swift
//
//
//  Created by Cris Messias on 26/01/24.
//

import SwiftUI
import Leaf

public struct LoginCheckView: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginCheckViewModel

    public init(viewModel: LoginCheckViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            Divider()
            VStack(spacing: 24) {
                ImageLoginCheck(imageName: "check-email")
                Message(viewModel: viewModel)
                Spacer()
                ButtonOpenEmailApp()
            }
            .padding([.leading, .trailing], 16)
            .navigationTitle("Email Sent")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LoginCheckView(viewModel: LoginCheckViewModel())
        .previewCustomFonts()
}

struct ImageLoginCheck: View {
    var imageName: String
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: 300)
            .background(.green)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaledToFit()
            .padding(.top, 24)
    }
}

struct Message: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginCheckViewModel

    var body: some View {
        VStack(spacing: 8) {
            Text("Check your email!")
                .title()
            Text("To confirm your email address, tap the button in the email we sent to **\(viewModel.mockEmail)**")
                .body()
        }
    }
}

struct ButtonOpenEmailApp: View {
    @Environment(\.leafTheme) private var theme
    var body: some View {
        Button("Open Email App") {

        }
        .buttonStyle(LeafPrimaryButton())
        .padding(24)
    }
}
