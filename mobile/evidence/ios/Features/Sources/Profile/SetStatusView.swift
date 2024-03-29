//
//  SetStatusView.swift
//  Evidence
//
//  Created by Cris Messias on 09/11/23.
//

import SwiftUI
import Leaf


public struct SetStatusView: View {
    @ObservedObject var model: SetStatusViewModel
    @Environment(\.leafTheme) private var theme

    public init(model: SetStatusViewModel) {
        self.model = model
    }

    public var body: some View {
        NavigationView {
            VStack {
                InputStatus(model: model)
                Spacer()
            }
            .padding(.horizontal, 16)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        model.closeButtonTapped()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(theme.color.text.primary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if model.isClearButtonShowing {
                        Button(action: {
                            model.clearAndSaveButtonTapped()
                        }, label: {
                            Text("Clear")
                                .foregroundStyle(theme.color.warning.error)
                        })
                    } else {
                        Button(action: {
                            model.saveButtonTapped()
                        }, label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(!model.statusInput.isEmpty ? theme.color.warning.success: theme.color.state.disabled
                                )
                        })
                        .navigationBarTitle("Set a Status", displayMode: .inline)
                    }
                }
            }
        }
    }
}

struct InputStatus: View {
    @ObservedObject var model: SetStatusViewModel
    @Environment(\.leafTheme) private var theme

    var body: some View {
        Divider()
        HStack {
            HStack {
                if model.statusInput.isEmpty {
                    Image(systemName: "smiley")
                        .foregroundColor(theme.color.text.secondary)
                }  else {
                    Text("💬")
                }
                TextField("What's your status?", text: $model.statusInput)
                    .body()
            }
            Spacer()
            Button(action: {
                model.clearStatusInputTextFieldTapped()
            }){
                if !model.statusInput.isEmpty {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(theme.color.text.secondary)
                }
            }
        }
        .padding(.vertical, 8)
        Divider()
    }
}

#Preview {
    SetStatusView(model: SetStatusViewModel())
        .previewCustomFonts()
}
