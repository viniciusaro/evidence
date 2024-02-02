//
//  LoginEmailView.swift
//
//
//  Created by Cris Messias on 23/01/24.
//

import SwiftUI
import Leaf

public struct LoginEmailView: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginEmailViewModel

    public var body: some View {
        NavigationStack {
            Divider()
            VStack(alignment:.leading, spacing: 24) {
                EmailInput(viewModel: viewModel)
                Label()
                NextButton(viewModel: viewModel)
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
            .navigationTitle("Sign In with Email")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LoginEmailView(viewModel: LoginEmailViewModel())
        .previewCustomFonts()
}

struct Label: View {
    @Environment(\.leafTheme) private var theme

    var body: some View {
        Text("We'll send you an email to confirm your address.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .label()
    }
}

struct NextButton: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginEmailViewModel
    
    var body: some View {
        NavigationStack {
            Button("Next") {
                viewModel.buttonNextTapped()
            }
            .buttonStyle(LeafPrimaryButton())
            .navigationDestination(item: $viewModel.loginCheckViewModel) { loginCheckViewModel in
                LoginCheckEmailView(viewModel: loginCheckViewModel)
            }
        }
    }
}

struct EmailInput: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var viewModel: LoginEmailViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Enter You Email Address")
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
        if let errorMessage = viewModel.errorMessage() {
            LeafError(message: errorMessage)
        }
    }
}


