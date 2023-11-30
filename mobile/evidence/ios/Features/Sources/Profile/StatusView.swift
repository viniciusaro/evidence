//
//  StatusView.swift
//  
//
//  Created by Cris Messias on 12/11/23.
//

import SwiftUI
import Leaf

public struct StatusView: View {
    @ObservedObject var model: StatusViewModel
    @Environment(\.leafTheme) private var theme
    
    public init(model: StatusViewModel) {
        self.model = model
    }
    
    public var body: some View {
        Button(action: {
            model.statusInputButtonTapped()
        }) {
            ZStack(alignment: .leading) {
                HStack {
                    HStack {
                        if model.statusInput.isEmpty {
                            Image(systemName: "smiley")
                                .foregroundColor(theme.color.gray.primary70)
                        }  else {
                            Text("💬")
                        }
                        
                        Text(model.statusInput.isEmpty ? "What's your status?" : model.statusInput)
                            .foregroundColor(model.statusInput.isEmpty ? theme.color.gray.primary70 : theme.color.core.black)
                            .body()
                    }
                    Spacer()
                    
                    Button(action: {
                        model.clearStatusInputButtonTapped()
                    }){
                        if !model.statusInput.isEmpty {
                            Image(systemName: "xmark")
                                .foregroundStyle(theme.color.gray.primary50)
                        }
                    }
                    .alert(isPresented: Binding.constant(model.isAlertShowing)) {
                        Alert(
                            title: Text("✅"),
                            message: Text("Status Cleared")
                        )
                    }
                }
                .padding(.horizontal, 16)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(theme.color.gray.primary50, lineWidth: 0.5)
                    .frame(height: 55)
            }
            .padding(.horizontal, 16)
        }
        .sheet(isPresented: Binding.constant(model.isModalShowing), content: {
            SetAStatusView(model: model)
        })
    }
}

#Preview {
    StatusView(model: StatusViewModel())
}

