//
//  CreateAccountEmailView.swift
//
//
//  Created by Cris Messias on 23/01/24.
//

import SwiftUI
import Leaf


public struct CreateAccountEmailView: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: CreateAccountEmailViewModel

    public var body: some View {
        NavigationStack {
            Divider()
            VStack(alignment:.leading, spacing: 24) {
                EmailInput(viewModel: viewModel)
                PasswordInput(viewModel: viewModel)
                CreateAccountButton(viewModel: viewModel)
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
            .navigationTitle("Create account with Email")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CreateAccountEmailView(viewModel: CreateAccountEmailViewModel())
        .previewCustomFonts()
}

struct CreateAccountLabel: View {
    @Environment(\.leafTheme) private var theme

    var body: some View {
        Text(" Needs at least 8 characters")
            .frame(maxWidth: .infinity, alignment: .leading)
            .label()
    }
}

struct CreateAccountButton: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: CreateAccountEmailViewModel

    var body: some View {
        NavigationStack {
            Button("Create Account") {
                viewModel.createAccountButtonTapped()
            }
            .buttonStyle(LeafPrimaryButtonStyle())
        }
    }
}

struct EmailInput: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: CreateAccountEmailViewModel
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

struct PasswordInput: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: CreateAccountEmailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Create Your Password")
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
            LeafErrorMessageStyle(message: errorMessage)
        }
    }
}


