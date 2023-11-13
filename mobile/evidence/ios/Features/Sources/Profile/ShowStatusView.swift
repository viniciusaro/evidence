//
//  ShowStatusView.swift
//  
//
//  Created by Cris Messias on 12/11/23.
//

import SwiftUI
import Leaf

public struct ShowStatusView: View {
    @ObservedObject var model: StatusViewModel
    @Environment(\.leafTheme) private var theme
    
    public init(model: StatusViewModel) {
        self.model = model
    }
    
    public var body: some View {
        Button(action: {
            model.isModalShowing()
        }) {
            ZStack(alignment: .leading) {
                HStack {
                    HStack {
                        if model.statusInput.isEmpty {
                            Image(systemName: "smiley")
                                .foregroundColor(theme.color.content.tertiary)
                        }  else {
                            Text("💬")
                        }
                        
                        Text(model.statusInput.isEmpty ? "What's your status?" : model.statusInput)
                            .foregroundColor(model.statusInput.isEmpty ? theme.color.content.tertiary : theme.color.content.primary)
                            .body()
                    }
                    Spacer()
                    Button(action: {
                        model.clearStatus()
                        model.toggleButton()
                        model.isAlertShowing()
                    }){
                        if !model.statusInput.isEmpty {
                            Image(systemName: "xmark")
                                .foregroundStyle(theme.color.content.tertiary)
                        }
                    }
                    .alert(isPresented: Binding.constant(model.showAlert)) {
                        Alert(
                            title: Text("✅"),
                            message: Text("Status Cleared")
                        )
                    }
                }
                .padding(.horizontal, 16)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(theme.color.content.tertiary, lineWidth: 0.5)
                    .frame(height: 55)
            }
            .padding(.horizontal, 16)
        }
        .sheet(isPresented: Binding.constant(model.showModal), content: {
            SetAStatusView(model: model)
        })
    }
}

#Preview {
    ShowStatusView(model: StatusViewModel())
}

