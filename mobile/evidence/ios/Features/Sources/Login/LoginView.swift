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

    public init(model: LoginViewModel) {
        self.viewModel = model
    }

    public var body: some View {
        VStack {
            Text("Slack brings teams together, wherever you are")
                .foregroundStyle(.white)
                .font(.custom("Lato-Bold", size: 26))
                .padding(EdgeInsets(top: 40, leading: 16, bottom: 0, trailing: 16))
            Spacer()
            Image("login-image")
                .resizable()
                .scaledToFit()
                .padding(.leading, 20)
            Spacer()
            Button("Getting Started") {
                viewModel.openModalTapped()
            }
            .buttonStyle(LeafSecondaryButton())
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 40, trailing: 16))
            .sheet(isPresented: $viewModel.showLoginTypes) {
                LoginDifferentTypes(model: viewModel)
                    .presentationDetents([.height(220)])
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accentColor(Color.white)
        .background(theme.color.brand.aubergine)
    }
}

#Preview {
    LoginView(model: LoginViewModel())
        .previewCustomFonts()
}


struct LoginDifferentTypes: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var model: LoginViewModel


    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Button("Continue with Gmail") {
                    model.showModalGoogle = true //model
                }
                .buttonStyle(LeafGoogleLoginButton())
                .sheet(isPresented: $model.showModalGoogle) {

                }

                Button("Continue with Email") {
                    model.buttonLoginEmailTapped()
                }
                .buttonStyle(LeafPrimaryButton())
                .sheet(item: $model.loginEmailViewModel) { loginEmailViewModel in
                    LoginEmailView(viewModel: loginEmailViewModel)

                }
            }
            .padding([.leading, .trailing], 16)
        }
    }
}

//#Preview {
//    LoginDifferentTypes(model: LoginViewModel())
//        .previewCustomFonts()
//
//}
