//
//  SetStatusView.swift
//  Evidence
//
//  Created by Cris Messias on 09/11/23.
//

import SwiftUI
import Leaf


public struct SetStatusView: View {
    @ObservedObject var model: StatusViewModel
    @Environment(\.leafTheme) private var theme
    
    public init(model: StatusViewModel) {
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
                        model.closeModalButtonTapped()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(theme.color.core.black)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        model.clearOrSaveButtonTapped()
                    }) {
                        if model.isClearButtonShowing {
                            Text("Clear")
                                .foregroundStyle(theme.color.core.red)
                        } else {
                            Image(systemName: "checkmark")
                                .foregroundColor(!model.statusInput.isEmpty ? theme.color.secondary.sky : theme.color.gray.primary13)
                        }
                    }
                }
            }
            .navigationBarTitle("Set a Status", displayMode: .inline)
        }
    }
}

struct InputStatus: View {
    @ObservedObject var model: StatusViewModel
    @Environment(\.leafTheme) private var theme
    
    var body: some View {
        Divider()
        HStack {
            HStack {
                if model.statusInput.isEmpty {
                    Image(systemName: "smiley")
                        .foregroundColor(theme.color.gray.primary70)
                }  else {
                    Text("💬")
                }
                TextField("What's your status?", text: $model.statusInput)
            }
            Spacer()
            Button(action: {
                model.clearStatusInputTextFieldTapped()
            }){
                if !model.statusInput.isEmpty {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(theme.color.gray.primary50)
                }
            }
        }
        .padding(.vertical, 8)
        Divider()
    }
}

#Preview {
    SetStatusView(model: StatusViewModel())
}
