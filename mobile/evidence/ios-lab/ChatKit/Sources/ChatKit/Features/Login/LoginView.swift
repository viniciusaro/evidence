//
//  LoginViewModel.swift
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
            LeafImageLogin()
            Spacer()
            GettingStartedButton(viewModel: viewModel)
        }
        .background(theme.color.backgrond.aubergine)
    }
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

struct GettingStartedButton: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        Button("Getting Started") {
            viewModel.gettingStartedButtonTapped()
        }
        .buttonStyle(LeafSecondaryButtonStyle())
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 40, trailing: 16))
        .sheet(isPresented: $viewModel.showLoginAuthModal) {
            LoginAuthModal(viewModel: viewModel)
                .presentationDetents([.height(274)])
        }
    }
}

struct LoginAuthModal: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Button("Continue with Email") {
                    viewModel.continueWithEmailButtonTapped()
                }
                .buttonStyle(LeafPrimaryButtonStyle())
                Button("Create Account") {
                    viewModel.createAccountButtonTapped()
                }
                .buttonStyle(LeafSecondaryButtonStyle())
                
            }
            .sheet(item: $viewModel.loginEmailViewModel) { viewModel in
                LoginEmailView(viewModel: viewModel)
            }
            .sheet(item: $viewModel.createAccountEmail) { viewModel in
                CreateAccountEmailView(viewModel: viewModel)
            }
            .padding([.leading, .trailing], 16)
            .padding([.top, .bottom], 24)
        }
    }
}

#Preview {
    LoginAuthModal(viewModel: LoginViewModel())
        .previewCustomFonts()
}
