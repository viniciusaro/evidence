//
//  LoginEmailView.swift
//
//
//  Created by Cris Messias on 02/04/24.
//

import SwiftUI
import Leaf

public struct LoginEmailView: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginEmailViewModel

    public var body: some View {
        NavigationStack {
            Divider()
            ZStack() {
                VStack(alignment:.leading, spacing: 24) {
                    LoginEmailInput(viewModel: viewModel)
                    LoginEmailPasswordInput(viewModel: viewModel)
                    VStack(alignment:.leading, spacing: 8) {
                        LoginEmailButton(viewModel: viewModel)
                        LoginResetPassordButton(viewModel: viewModel)
                    }
                    Spacer()
                }
                .padding(.top, 24)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            viewModel.closeButtonTapped()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundStyle(theme.color.text.primary)
                        }
                    }
                }
                .padding([.leading,.trailing], 16)
                .navigationTitle("Continue with Email")
                .navigationBarTitleDisplayMode(.inline)
                LeaAlert(state: .confirmation)
                    .frame(width: 230 , height: 200)
                    .offset(x: 0, y: viewModel.AlertOffSetY)
            }
        }
    }
}

#Preview {
    LoginEmailView(viewModel: LoginEmailViewModel())
}

struct LoginEmailLabel: View {
    @Environment(\.leafTheme) private var theme

    var body: some View {
        Text(" Needs at least 8 characters")
            .frame(maxWidth: .infinity, alignment: .leading)
            .label()
    }
}

struct LoginEmailButton: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginEmailViewModel

    var body: some View {
        NavigationStack {
            Button("Continue") {
                viewModel.loginEmailButtonTapped()
            }
            .buttonStyle(LeafPrimaryButtonStyle())

        }
    }
}

struct LoginEmailInput: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginEmailViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Enter Your Email Address")
                .body()

            HStack {
                TextField("nome@email. com", text: $viewModel.emailInput)
                    .focused($isFocused)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .foregroundStyle(theme.color.text.primary)
                    .body()
                    .frame(height: 50)
                    .onTapGesture {
                        viewModel.inputEmailTapped()
                    }
                    .onAppear  {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.isFocused = true
                        }
                        self.isFocused = viewModel.isEmailInputFocused
                    }

                Button(action: {
                    viewModel.clearEmailInputTapped()
                }) {
                    if !viewModel.emailInput.isEmpty {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(theme.color.text.secondary)
                    }
                }

            }
            .padding([.leading, .trailing], 16)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(theme.color.text.secondary, lineWidth: 0.5)
            }

        }
    }
}

struct LoginEmailPasswordInput: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginEmailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Enter Your Password")
                .body()

            HStack {
                SecureField("password", text: $viewModel.passwordInput)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .foregroundStyle(theme.color.text.primary)
                    .body()
                    .frame(height: 50)
                    .onTapGesture {
                        viewModel.inputEmailTapped()
                    }

                Button(action: {
                    viewModel.clearPasswordInputTapped()
                }) {
                    if !viewModel.passwordInput.isEmpty {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(theme.color.text.secondary)
                    }
                }
            }
            .padding([.leading, .trailing], 16)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(theme.color.text.secondary, lineWidth: 0.5)
            }
            CreateAccountLabel()

        }
        if let errorMessage = viewModel.errorMessage() {
            LeafErrorMessage(message: errorMessage)
        }
    }
}

struct LoginResetPassordButton: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginEmailViewModel

    var body: some View {
            Button("Reset password") {
                viewModel.resetPassworButtonTapped()
            }
            .buttonStyle(LeaflinkButtonStyle())
            .sheet(item: $viewModel.loginResetPassword) { loginResetPassword in
                LoginResetPasswordView(viewModel: loginResetPassword)
            }
    }
}
