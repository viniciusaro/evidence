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
    @State private var isUserAuthenticated: Bool
    var loginSettingViewModel: LoginSettingModel

    public init(
        viewModel: LoginViewModel,
        isUserAuthenticated: Bool = false,
        loginSettingViewModel: LoginSettingModel
    ) {
        self.viewModel = viewModel
        self.isUserAuthenticated = isUserAuthenticated
        self.loginSettingViewModel = loginSettingViewModel
    }

    public var body: some View {
        ZStack {
            NavigationStack {
                LoginSetting(viewModel: loginSettingViewModel, isUserAuthenticated: $isUserAuthenticated)
            }
        }
        .onAppear {
            let autheUser = try? LoginManager.shared.getAuthenticationUser()
            isUserAuthenticated = autheUser == nil
        }
        .fullScreenCover(isPresented: $isUserAuthenticated, content: {
            VStack {
                Title()
                Spacer()
                GettingStartedButton(viewModel: viewModel)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(theme.color.backgrond.aubergine)
        })

    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(), loginSettingViewModel: LoginSettingModel())
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

struct GettingStartedButton: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        Button("Getting Started") {
            viewModel.gettingStartedButtonTapped()
        }
        .buttonStyle(LeafSecondaryButton())
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 40, trailing: 16))
        .sheet(isPresented: $viewModel.showLoginAuthModal) {
            LoginAuthModal(viewModel: viewModel)
                .presentationDetents([.height(220)])
        }
    }
}

struct LoginAuthModal: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Button("Continue with Gmail") {

                }
                .buttonStyle(LeafGoogleLoginButton())

                Button("Continue with Email") {
                    viewModel.loginEmailButtonTapped()
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
    LoginAuthModal(viewModel: LoginViewModel())
        .previewCustomFonts()

}
