//
//  LoginResetPasswordView.swift
//
//
//  Created by Cris Messias on 17/04/24.
//

import SwiftUI
import Leaf

struct LoginResetPasswordView: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginResetPasswordViewModel

    var body: some View {
        NavigationStack {
            Divider()
            VStack(alignment:.leading, spacing: 24) {
                ResetPasswordEmail(viewModel: viewModel)
                ResetPasswordButton(viewModel: viewModel)
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
            .navigationTitle("Reset Password")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ResetPasswordEmail: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginResetPasswordViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Enter Your Email")
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
            if let errorMessage = viewModel.errorMessage() {
                LeafErrorMessage(message: errorMessage)
            }
        }
    }
}

struct ResetPasswordButton: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginResetPasswordViewModel

    var body: some View {
        NavigationStack {
            Button("Reset") {
                viewModel.resetPasswordButtonTapped()
            }
            .buttonStyle(LeafPrimaryButtonStyle())
        }
    }
}

#Preview {
    LoginResetPasswordView(viewModel: LoginResetPasswordViewModel())
}
