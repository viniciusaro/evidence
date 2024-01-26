//
//  LoginView.swift
//
//
//  Created by Cris Messias on 19/01/24.
//

import SwiftUI
import Leaf

public struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @Environment(\.leafTheme) private var theme

    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack {
            Title()
            Spacer()
            ImageView(imageName: "login-image")
            Spacer()
            ButtonGettingStarted(viewModel: viewModel)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.color.brand.aubergine)
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
        .previewCustomFonts()
}
struct Title: View {
    var body: some View {
        Text("Slack brings teams together, wherever you are")
            .foregroundStyle(.white)
            .font(.custom("Lato-Bold", size: 26))
            .padding(EdgeInsets(top: 40, leading: 16, bottom: 0, trailing: 16))
    }
}

struct ImageView: View {
    var imageName: String

    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .padding(.leading, 20)
    }
}

struct ButtonGettingStarted: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        Button("Getting Started") {
            viewModel.buttonOpenModalTapped()
        }
        .buttonStyle(LeafSecondaryButton())
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 40, trailing: 16))
        .sheet(isPresented: $viewModel.showLoginAuth) {
            LoginAuth(viewModel: viewModel)
                .presentationDetents([.height(220)])
        }
    }
}

struct LoginAuth: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginViewModel


    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Button("Continue with Gmail") {
                    viewModel.showAuthGoogle = true //model
                }
                .buttonStyle(LeafGoogleLoginButton())
                .sheet(isPresented: $viewModel.showAuthGoogle) {
                }

                Button("Continue with Email") {
                    viewModel.buttonLoginEmailTapped()
                }
                .buttonStyle(LeafPrimaryButton())
                .sheet(item: $viewModel.loginEmailViewModel) { loginEmailViewModel in
                    LoginEmailView(viewModel: loginEmailViewModel)

                }
            }
            .padding([.leading, .trailing], 16)
        }
    }
}

#Preview {
    LoginAuth(viewModel: LoginViewModel())
        .previewCustomFonts()

}
