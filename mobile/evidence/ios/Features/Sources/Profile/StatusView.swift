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
            model.openModalButtonTapped()
        }) {
            ZStack() {
                StatusButtonView(model: model)
                LeaAlert(state: model.popupState)
                    .frame(width: 170, height: 150)
                    .offset(x: 0, y: model.offSetY)
            }
            .padding(.horizontal, 16)
        }
        .sheet(item: $model.setStatusViewModel) { setStatusViewModel in
            SetStatusView(model: setStatusViewModel)
        }
    }
}

struct StatusButtonView: View {
    @ObservedObject var model: StatusViewModel
    @Environment(\.leafTheme) private var theme
    var body: some View {
        HStack {
            HStack {
                if model.statusInput.isEmpty {
                    Image(systemName: "smiley")
                        .foregroundColor(theme.color.text.secondary)
                }  else {
                    Text("💬")
                }
                
                Text(model.statusInput.isEmpty ? "What's your status?" : model.statusInput)
                    .foregroundColor(model.statusInput.isEmpty ? theme.color.text.secondary : theme.color.text.primary)
                    .body()
            }
            Spacer()
            
            Button(action: {
                model.clearStatusInputButtonTapped()
            }){
                if !model.statusInput.isEmpty {
                    Image(systemName: "xmark")
                        .foregroundStyle(theme.color.text.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .overlay(content: {
            RoundedRectangle(cornerRadius: 10)
                .stroke(theme.color.text.secondary, lineWidth: 0.5)
                .frame(height: 55)
        })
    }
}

#Preview {
    StatusView(model: StatusViewModel())
        .previewCustomFonts()
}
