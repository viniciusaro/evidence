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
    @ObservedObject var model: LoginEmailViewModel

    public var body: some View {
        NavigationStack {
            Divider()
            VStack(spacing: 32) {
                EmailInput(model: model)
                Text("We will send you an email to confirm your address")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .subtitle()
                Button("Log in") {
                    //Authentication
                }
                .buttonStyle(LeafPrimaryButton())
                Spacer()
            }
            .padding(.top, 24)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        model.closeButtonTapped()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(theme.color.font.primary)
                    }
                }
            }
            .padding([.leading,.trailing], 16)
            .navigationTitle("Log in with email")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LoginEmailView(model: LoginEmailViewModel())
        .previewCustomFonts()
}


struct EmailInput: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var model: LoginEmailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Enter your email")
                .body()
            HStack {
                TextField("nom@email", text: $model.emailInput)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .foregroundStyle(theme.color.font.primary)
                    .body()
                    .frame(height: 50)

                Button(action: {
                    model.clearEmailInputTapped()
                }) {
                    if !model.emailInput.isEmpty {
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
    }
}

