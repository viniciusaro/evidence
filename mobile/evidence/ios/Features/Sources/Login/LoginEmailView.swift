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
                Button("Next") {
                    viewModel.buttonNextTapped()
                }
                .buttonStyle(LeafPrimaryButton())
                Spacer()
            }
            .padding(.top, 24)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        viewModel.closeButtonTapped()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(theme.color.font.primary)
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
                    .foregroundStyle(theme.color.font.primary)
                    .body()
                    .frame(height: 50)
                    .onTapGesture {
                        viewModel.buttonPressed = false
                    }
                    .onAppear  {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.isFocused = true
                        }
                        self.isFocused = viewModel.isFocused
                    }
                Button(action: {
                    viewModel.clearEmailInputTapped()
                }) {
                    if !viewModel.emailInput.isEmpty {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(theme.color.font.secondary)
                    }
                }
            }
            .padding([.leading, .trailing], 16)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(theme.color.font.secondary, lineWidth: 0.5)
            }
        }
        if viewModel.buttonPressed && viewModel.emailInput.isEmpty {
            LeafError(message: "No email provided.")
        } else if viewModel.buttonPressed == true && !viewModel.emailInput.isEmpty && viewModel.emailValid == false {
            LeafError(message: "That doesn't look like a valid email address!")
        }
    }
}


